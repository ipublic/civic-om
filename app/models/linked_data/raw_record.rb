module LinkedData
  class RawRecord < CouchRest::Model::Base
    
    belongs_to :data_packet, :class_name => 'LinkedData::DataPacket'

    property :serial_number, String
    property :published, Time
    timestamps!


    design do
      
      view :by_serial_number
      view :by_data_source_id

    #   # view :by_data_resource_id_and_published
      view :by_unpublished, 
              :map =>"function(doc) {
                        if (doc['model']=='RawRecord' && doc['published']==null) {
                          emit(doc.data_source_id, 1);
                        }
                      }"
    end
  
    # def initialize
    #   use_database self.data_packet.staging_database_name
    # end
  
    def published?
      self.published
    end
  
  end
end
