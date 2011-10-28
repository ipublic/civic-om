require 'open_media/couch_rest_modelable'
module OpenMedia
  class CouchRestModelBase < CouchRest::Model::Base
    include ::OpenMedia::CouchRestModelable
    
  end
end