class LinkedData::DataSource < CouchRest::Model::Base
  
  CSV_SOURCE_TYPE = "csv"
  SHAPEFILE_SOURCE_TYPE = "shapefile"
  URL_SOURCE_TYPE = "url"
  
  belongs_to :authority, :class_name => "LinkedData::Authority"

  use_database SCHEMA_DATABASE

  property :term, String        # Escaped vocabulary name suitable for inclusion in IRI
  property :label, String       # User assigned name, RDFS#Label
  property :comment, String     # RDFS#Comment
  property :properties, [LinkedData::Property]

  property :file do
    property :original_filename
    property :content_type
    property :tempfile
  end
  
  # property :transform_model do
  #   property :exe_order, Float
  #   property :source_property_term, String
  #   property :destination_topic_id, String
  #   property :destination_topic_property_term, String
  #   property :method, String
  #   property :parameters, String
  # end
  
  timestamps!
  
  validates_presence_of :term
  validates_presence_of :authority
  
  design do
    view :by_term
    view :by_label
    view :by_authority_id
  end
  

end