class LinkedData::Authority < CouchRest::Model::Base
  use_database SITES_DATABASE
  unique_id :identifier

  property :uri, String
  property :term, String
  property :label, String
  property :identifier, String, :read_only => true
  timestamps!

  ## Callbacks
  before_create :init_authority

  validates_presence_of :term
  validates_format_of :term, with: /^[a-z0-9_]+$/, message: "must be lowercase alphanumerics only"
  validates_length_of :term, maximum: 32, message: "exceeds maximum of 32 characters"
  validates_exclusion_of :term, in: Subdomain::BLACK_LIST, message: "is not available"
  validates_uniqueness_of :term, :view => 'by_term', message: "is already in use"
  
  design do
    view :by_term
    view :by_uri
  end

  def sites
    Site.by_authority_id(:key => self.id).all
  end

  def contacts
    Vocabularies::VCard::Base.by_authority_id(:key => self.id).all
  end

  def users
    User.by_authority_id(:key => self.id).all
  end

private
  def init_authority
    class_basename = self.class.to_s.demodulize.downcase
    write_attribute(:identifier,  %W[#{class_basename} #{self.term}].join('_'))
  end

end