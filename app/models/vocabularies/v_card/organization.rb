module Vocabularies
  class VCard::Organization < Hash
    include CouchRest::Model::Embeddable

    # based on vcard properties
    property :name, :alias => :organization_name
    property :department, :alias => :organization_unit

  end
end