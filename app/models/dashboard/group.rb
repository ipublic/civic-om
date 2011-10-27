module Dashboard
  class Group < Hash
    include CouchRest::Model::Embeddable

    property :title
    property :description
    property :measures, [Dashboard::Measure], :default => []

  end
end