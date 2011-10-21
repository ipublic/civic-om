module Vocabularies
  class VCard::Address < Hash
    include CouchRest::Model::Embeddable

    ADDRESS_TYPES = %w(Home Work)
    COUNTRY_TYPES = %w(USA)


    # based on vcard properties
    property :type, String
    property :address_1, String, :alias => :street_address
    property :address_2, String, :alias => :extended_address
    property :city, String, :alias => :locality
    property :state, String, :alias => :region
    property :zipcode, String, :alias => :postal_code
    property :country, String, :alias => :country_name

    def to_html
      address_str = ""
      address_str << "#{address_1}" unless address_1.blank?
      address_str << "<br/>#{address_2}" unless address_2.blank?
      address_str << "<br/>#{city}" unless city.blank?
      address_str << ", #{state}" unless state.blank?
      address_str << " #{zipcode}" unless zipcode.blank?
      address_str << "<br/>#{country}" unless country.blank?
      address_str
    end

  end
end