class Authority < DocumentBase

  use_database SITES_DATABASE

  proxy_for :data_sources
  proxy_database_method :staging_database_name

  property :site_domain, String
  property :staging_database_name, String, :read_only => true
  timestamps!

  validates_presence_of :site_domain
  validates_uniqueness_of :site_domain, :view => 'by_site_domain', message: "is already in use"
  # validates_exclusion_of :site_domain, in: Subdomain::BLACK_LIST, message: "is not available"
  
  ## Callbacks
  before_create :init_authority

  design do
    view :by_term
    view :by_site_domain
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
  
  def uri_string
    return if self.term.empty?
    uri = RDF::URI.new("http://civicopenmedia.us")/self.term 
    uri.to_s
  end

private
  def init_authority
    # class_basename = self.class.to_s.demodulize.downcase
    # write_attribute(:identifier,  %W[#{class_basename} #{self.term}].join('_'))

    write_attribute(:term, escape_string(self.site_domain))
    write_attribute(:identifier, self.term)
    write_attribute(:staging_database_name,  %W[#{self.term} staging].join('_'))
  end
  
end