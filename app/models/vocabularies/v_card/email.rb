module Vocabularies
  class VCard::Email < Hash
    include CouchRest::Model::Embeddable

    EMAIL_TYPES = %w(Home Work)

    # based on vcard properties
    property :type   # Home, Work
    property :value

  end
end