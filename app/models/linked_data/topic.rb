class LinkedData::Topic < LinkedData::CouchRestModelSchema
  
  attr_reader :instance_database, :instance_database_name, :instance_design_doc, :instance_design_doc_id
  attr_accessor :docs_read, :docs_written
  
  unique_id :identifier

  belongs_to :authority, :class_name => "LinkedData::Authority"
  belongs_to :vocabulary, :class_name => "LinkedData::Vocabulary"
  belongs_to :creator, :class_name => "VCard::Base"
  belongs_to :publisher, :class_name => "VCard::Base"

  # property :instance_database_name, String
  property :instance_class_name, String, :read_only => true
  
  timestamps!

  validates_presence_of :term
  validates_presence_of :authority
  validates_presence_of :instance_database_name
  
  ## Callbacks
  before_create :generate_identifier
  before_create :create_instance_design_doc
  before_destroy :destroy_instance_database

  design do
    view :by_term
    view :by_label
    view :by_authority_id
  end
  
  def record_count
    return 0 if self.instance_class_name.nil?
    instance_database.view("#{self.instance_class_name}/all", {:include_docs => false})["total_rows"]
  end
  
  def instance_database_name
    return if self.authority.nil? || self.term.nil?
    @instance_database_name ||= (%W[#{COUCHDB_CONFIG["db_prefix"]} #{self.authority.term} staging #{COUCHDB_CONFIG["db_suffix"]}].select {|v| !v.blank?}.join("_"))
    
    [self.authority.term, self.term].join('_')
  end
  
  def instance_database
    return unless instance_database_name.present? && self.identifier.present?
    @instance_database ||= COUCHDB_SERVER.database!(instance_database_name)
  end
  
  def instance_design_doc
    return if instance_design_doc_id.nil?
    @instance_design_doc ||= instance_database.get(instance_design_doc_id) 
  end
  
  def instance_design_doc_id
    return if self.instance_class_name.nil?
    @instance_design_doc_id ||= "_design/#{self.instance_class_name}" 
  end
  
  # Provide a CouchRest::Document for this Topic with set database and model_type_key
  def new_instance_doc(options={})
    return if self.instance_class_name.nil?
    params = options.merge(model_type_key.to_sym => self.instance_class_name)
    doc = CouchRest::Document.new(params)
    
    doc.database = instance_database
    doc
  end
   
  def load_instance_docs(docs=[])
    ts = Time.now.utc.iso8601.to_s
    time_stamp = {:created_at => ts, :updated_at => ts}

    # Reserved properties from source doc to ignore during load
    rp = %W[_id _rev model created_at updated_at published]
    db = instance_database

    docs.each do |doc| 
      pub_doc = new_instance_doc(doc.to_hash.delete_if {|k, v| rp.include? k}.merge(time_stamp)) 
      self.docs_read += 1

      pub_doc.save(true)
      self.docs_written += 1
      db.bulk_save if docs_written%500 == 0              
    end
    db.bulk_save
    docs_written
  end
  
  def add_instance_view(*keys)
    return if instance_class_name.nil?
    opts = keys.pop if keys.last.is_a?(Hash)
    opts ||= {}
    ducktype = opts.delete(:ducktype)
    unless ducktype || opts[:map]
      opts[:guards] ||= []
      # opts[:guards].push "(doc['#{model_type_key}'] == '#{self.instance_class_name}')"
      opts[:guards].push "(doc['model'] == '#{self.instance_class_name}')"
    end
    keys.push opts
    dsn = instance_design_doc
    dsn.view_by(*keys)
    dsn.save
  end
  
  # Use bulk_save to delete all data instances for this topic
  def destroy_instance_docs!
    doc_list = instance_design_doc.view(:all)
    destroy_count = doc_list['total_rows']
    return destroy_count if destroy_count < 1
    
    docs = instance_database.get_bulk(doc_list['rows'].map {|rh| rh['id']})
    docs['rows'].each {|rh| instance_database.delete_doc(rh['doc'], false)}
    instance_database.bulk_delete

    destroy_count
  end
  
  def docs_read
    @docs_read ||= 0
  end
  
  def docs_written
    @docs_written ||= 0
  end
  
  # Delete all data instance docs and design doc
  def destroy_instance_database
    instance_database.delete!
  end
  
  # Create a dynamic CouchRest::Model::Base class for this Topic
  def couchrest_model
    ## TODO - deprecate this method
    return if self.term.nil? || instance_database.nil? || self.vocabulary.nil?
    
    write_attribute(:instance_class_name, self.term.singularize.camelize)

    if Object.const_defined?(self.instance_class_name.intern)
      klass = Object.const_get(self.instance_class_name.intern)
    else
      db = instance_database
      prop_list = self.vocabulary.properties.inject([]) {|plist, p| plist << p}
      type_list = self.vocabulary.types.inject([]) {|tlist, t| tlist << t} 
      
      klass = Object.const_set(self.instance_class_name.intern, 
        Class.new(CouchRest::Model::Base) do
          use_database db
          prop_list.each {|p| property p.term.to_sym}
          property :serial_number
          property :data_source_id
          timestamps!

          # type_list.each |t| do
          #   property t.to_sym do
          #     t.properties.each {|tp| property tp.term.to_sym}
          #   end
          # end
          # 
          design do
            view :by_serial_number
            view :by_data_source_id
          end
          
        end
        )
    end
    klass
  end
  
private

  # Instantiate a CouchDB Design Document for this Topic's data
  def create_instance_design_doc
    write_attribute(:instance_class_name, self.term.singularize.camelize)

    ddoc = CouchRest::Document.new(:_id => self.instance_design_doc_id,
                                 :language => "javascript",
                                 :views => {
                                  :all => {
                                    :map =>
                                      "function(doc) {if (doc['#{model_type_key}'] == '#{self.instance_class_name}'){emit(doc['_id'],1);}}"
                                    }
                                  }
                                  )
    
    instance_database.save_doc(ddoc)
    add_instance_vocabulary_views
  end

  # Add instance CouchDB Design Document views for each key in Vocaulary
  def add_instance_vocabulary_views
    return if self.vocabulary.nil?
    self.vocabulary.key_list.each {|k| add_instance_view(k)}
    instance_design_doc
  end

  def spatial_view
    {:spatial => {
      :full => "function(doc) {if (doc.geometry) {emit(doc.geometry, {id: doc._id, geometry: doc.geometry}); }}",
      :minimum => "function(doc) {if (doc.geometry) {emit(doc.geometry, 1); }}"
      }
    }
  end
  
end
