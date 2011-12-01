require 'open_media/couch_rest_modelable'
module LinkedData
  class CouchRestModelSchema < CouchRest::Model::Base
    include ::OpenMedia::CouchRestModelable

    use_database SCHEMA_DATABASE
    unique_id :identifier

    property :identifier, String
    property :term, String        # Escaped vocabulary name suitable for inclusion in IRI
    property :label, String       # User assigned name, RDFS#Label
    property :authority, String
    property :comment, String     # RDFS#Comment
    
  end
end
