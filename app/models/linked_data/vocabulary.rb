class LinkedData::Vocabulary < LinkedData::CouchRestModelSchema
  
  attr_accessor :key_list
  
  # belongs_to :collection, :class_name => "LinkedData::Collection"
  belongs_to :authority, :class_name => "LinkedData::Authority"
  
  property :tags, [String]

  property :base_uri, String
  property :curie_prefix, String
  property :curie_suffix, String
  property :property_delimiter, String, :default => "/"
  property :context
  
  property :properties, [LinkedData::Property]
  collection_of :types, :class_name => 'LinkedData::Type'

  # Provide enumerations in the following example format:
    # p = {"clown" => {"c" => "circus", "r" => "rodeo"}, "category" => {"a" => "animal", "v" => "vegetable", "m" => "mineral"}}
  property :enumerations, :default => {}

  ## TODO -- move geometries into Properties
  # property :geometries, [GeoJson::Geometry]
  
  timestamps!

  validates_presence_of :term
  validates_presence_of :authority
  # validates_presence_of :collection
  validates_uniqueness_of :identifier, :view => 'all'
  
  
  ## Callbacks
  before_create :generate_identifier

  design do
    view :by_term
    view :by_label
    view :by_authority
    
    view :by_curie_prefix
  
    view :tag_list,
      :map =>
        "function(doc) {
          if (doc['model'] == 'LinkedData::Vocabulary' && doc.tags) {
            doc.tags.forEach(function(tag) {
              emit(tag, 1); 
              });
            }
          }"
          
  end
  
  # view_by :has_geometry,
  #   :map => 
  #     "function(doc) {
  #       if ((doc['model'] == 'LinkedData::Vocabulary') && (doc.geometries.length > 0 )) { 
  #         doc.geometries.forEach(function(geometry) {
  #           emit(geometry, 1);
  #           });
  #         }
  #       }"
  
  
  def key_list
    return [] if self.properties.nil?
    @key_list ||= self.properties.inject([]) {|list, k| k.key ? list.push(k.term) : list }
  end
  
  def curie
    Hash[self.curie_prefix, self.curie_suffix] if self.curie_prefix && self.curie_suffix
  end
  
  def decode(property_name, key)
    self.enumerations[property_name][key]
  end

  ##
  # Returns the Vocabularies for passed Collection.
  #
  # @return [Vocabulary]
  # def self.find_by_collection_id(col_id)
  #   self.by_collection_id(:key => col_id)
  # end

  ##
  # Returns a JSON representation of this vocabulary.
  #
  # @return {JSON}
  def to_json
    # all_props_hsh = Hash.new
    # self.properties.each do |prop|
    #   prop_hsh[prop.]
    # end
    # 
    # prop_hash = Hash.new {}
    # 
    # self.types.each do |t|
    #   
    #   {|t| puts t.label ; t.properties.each {|p| puts '|-' + p.label}}
    # end

  end

  ##
  # Returns a hash of CURIE and Namespaces used to define this vocabulary
  #
  # @return {CURIE key, Namespace value}
  def context
    # namespaces = Hash.new
    # self.properties.each { |prop| namespaces[prop.namespace.alias.to_s] = prop.namespace.iri_base.to_s }
    # namespaces
  end
  
  ## Return a Hash with URIs as key's and Vocaulary hashes in an associated Array
  ## Calling with an empty Collection_id will return all Vocaularies
  # def self.sort_by_base_uri(collection_id = '')
  #   @sorted_vocabularies = Hash.new
  #   if collection_id.empty?
  #     all_vocabs = LinkedData::Vocabulary.all
  #   else
  #     all_vocabs = LinkedData::Vocabulary.by_collection_id(:key => collection_id)
  #   end
  #   
  #   all_vocabs.each do |v| 
  #     @sorted_vocabularies.key?(v.base_uri) ? @sorted_vocabularies[v.base_uri] << v : @sorted_vocabularies[v.base_uri] = Array.[](v)
  #   end
  #   @sorted_vocabularies
  # end
  
  ## Return a Hash with URIs as key's and Vocaulary hashes in an associated Array
  ## Calling with an empty Collection_id will return all Vocaularies
  # def self.sort_by_authority(collection_id = '')
  #   @sorted_vocabularies = Hash.new
  #   if collection_id.empty?
  #     all_vocabs = LinkedData::Vocabulary.all
  #   else
  #     all_vocabs = LinkedData::Vocabulary.by_collection_id(:key => collection_id)
  #   end
  #   
  #   all_vocabs.each do |v| 
  #     @sorted_vocabularies.key?(v.authority) ? @sorted_vocabularies[v.authority] << v : @sorted_vocabularies[v.authority] = Array.[](v)
  #   end
  #   @sorted_vocabularies
  # end
  
end