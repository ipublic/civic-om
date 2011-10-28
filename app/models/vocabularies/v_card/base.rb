module Vocabularies
  class VCard::Base < CouchRest::Model::Base
  
    use_database SCHEMA_DATABASE

    property :addresses, [Vocabularies::VCard::Address], :alias => :adr
    property :emails, [Vocabularies::VCard::Email], :alias => :email
    property :name, Vocabularies::VCard::Name, :alias => :n
    property :organization, Vocabularies::VCard::Organization, :alias => :org
    property :telephones, [Vocabularies::VCard::Telephone], :alias => :tel

    property :formatted_name, String, :alias => :fn
    property :nickname, String, :alias => :nickname
    property :sort_string, String
    property :title, String
    property :note, String

    timestamps!

    ## Callbacks
    # before_save :format_name
    before_validation :format_name
  
    validates_presence_of :formatted_name

    view_by :formatted_name
    view_by :sort_string

    view_by :last_name,
      :map => 
        "function(doc) {
          if ((doc['model'] == 'Vocabularies::VCard::Base') && (doc.name.last_name)) { 
            emit(doc.name.last_name, doc);
            }
          }"
  
    view_by :organization,
      :map => 
        "function(doc) {
          if ((doc['model'] == 'Vocabularies::VCard::Base') && (doc.organization.name)) { 
            emit(doc.organization.name, doc);
            }
          }"
        
  private
    def format_name
      return if self.name.nil?
      self.formatted_name = ""
      self.formatted_name << "#{self.name.prefix}" unless self.name['prefix'].nil? || self.name['prefix'].blank?
      self.formatted_name << " #{self.name.first_name}" unless self.name['first_name'].nil? || self.name.first_name.blank?
      self.formatted_name << " #{self.name.middle_name}" unless self.name['middle_name'].nil? || self.name.middle_name.blank?
      self.formatted_name << " #{self.name.last_name}" unless self.name['last_name'].nil? || self.name.last_name.blank?
      self.formatted_name << ", #{self.name.suffix}" unless self.name['suffix'].nil? || self.name.suffix.blank?

      self.formatted_name = self.formatted_name.strip
    end
  end
end