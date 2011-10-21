module Vocabularies
  class VCard::Name < Hash
    include CouchRest::Model::Embeddable

    # based on vcard properties
    property :first_name, String, :alias => :given_name
    property :middle_name, String, :alias => :additional_name
    property :last_name, String, :alias => :family_name
    property :prefix, String, :alias => :honorific_prefix
    property :suffix, String, :alias => :honorific_suffix

  end
end