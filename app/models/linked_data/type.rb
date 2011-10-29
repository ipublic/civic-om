class LinkedData::Type < LinkedData::CouchRestModelSchema
  
  use_database SCHEMA_DATABASE
  unique_id :identifier

  belongs_to :vocabulary, :class_name => "LinkedData::Vocabulary"

  # Properties denote a HAS A relationship. For example, iPublic Has a url (property) of
  # http://ipublic.org (value)
  property :properties, [LinkedData::Property]
  
  # Included types support set-based inclusion for building atop existing vocabulary definitions and to support 
  # inferencing.  For example, a resident is always a person, designating someone as a resident will 
  # provide access both to resident and person properties. Note: included properties aren't inheritance
  
  collection_of :included_types, :class_name => 'LinkedData::Type'
  
  property :public_uri, String
  property :tags, [String]

  property :enumerations           # Hash of key/value lookups
  property :sort_order

  timestamps!

  validates_presence_of :term
  validates_presence_of :vocabulary_id
  validates_uniqueness_of :identifier, :view => 'all'

  ## Callbacks
  before_create :generate_authority
  before_create :generate_public_uri
  before_create :generate_identifier
  
  def generate_authority
    self.authority = self.vocabulary.authority unless self.vocabulary.authority.nil?
  end

  design do
    view :by_term
    view :by_label
    view :by_authority
    
    view :by_public_uri
    view :by_vocabulary_id
    
    view :tag_list,
      :map =>
        "function(doc) {
          if (doc['model'] == 'LinkedData::Type' && doc.tags) {
            doc.tags.forEach(function(tag) {
              emit(tag, 1); 
              });
            }
          }"

    view :included_type_ids,
      :map =>
        "function(doc) {
          if (doc['model'] == 'LinkedData::Type' && doc.included_type_ids) {
            doc.included_type_ids.forEach(function(included_type_id) {
              emit(included_type_id, 1); 
              });
            }
          }"

  end

  def compound?
    self.properties.length > 0 ? true : false
  end

  def self.find_by_vocabulary_id(vocab_id)
    self.by_vocabulary_id(:key => vocab_id)
  end

end
