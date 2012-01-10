module Dashboard
  class Base < CouchRest::Model::Base
    use_database SCHEMA_DATABASE
    
    belongs_to :authority

    FORMATS = %w(percentage currency number string)
    VISUALS = %w(inlinesparkline pie inlinebar bullet)

    property :title
    property :description
    property :groups, [Dashboard::Group], :default => []

    timestamps!

    validates_presence_of :title
    validates_presence_of :authority
    
    design do
      view :by_authority_id
    end
    
  end
end