module Dashboard
  class Base < CouchRest::Model::Base

    # use_database SITES_DATABASE
    use_database VOCABULARIES_DATABASE

    FORMATS = %w(percentage currency number string)
    VISUALS = %w(inlinesparkline pie inlinebar bullet)

    ## Property Definitions
    # General properties
    property :title
    property :description
    property :groups, [Dashboard::Group], :default => []

    timestamps!

    validates :title, :presence => true
    view_by :title

  end
end