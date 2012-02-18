class Authority < CouchRest::Model::Base

  attr_reader :public_database, :staging_database_name, :staging_database
  
  use_database SITES_DATABASE
  unique_id :identifier

  proxy_for :data_sources
  proxy_database_method :staging_database_name

  property :uri, String
  property :term, String
  property :label, String
  property :identifier, String, :read_only => true
  property :staging_database_name, String, :read_only => true
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
  
  # def staging_database_name
  #   return unless self.term.present?
  #   @staging_database_name ||= (%W[#{COUCHDB_CONFIG["db_prefix"]} #{self.term} staging #{COUCHDB_CONFIG["db_suffix"]}].select {|v| !v.blank?}.join("_"))
  # end
  # 
  # def staging_database
  #   return unless staging_database_name
  #   @staging_database ||= COUCHDB_SERVER.database!(staging_database_name)
  # end

  def public_database_name
    return unless self.term.present?
    @public_database_name ||= (%W[#{COUCHDB_CONFIG["db_prefix"]} #{self.term} public #{COUCHDB_CONFIG["db_suffix"]}].select {|v| !v.blank?}.join("_"))
  end
  
  def public_database
    return unless public_database_name
    @public_database ||= COUCHDB_SERVER.database!(public_database_name)
  end

private
  def init_authority
    class_basename = self.class.to_s.demodulize.downcase
    write_attribute(:identifier,  %W[#{class_basename} #{self.term}].join('_'))
    write_attribute(:staging_database_name,  %W[#{self.term} staging].join('_'))
  end
  
  def init_site_dbs
    staging_database
    public_database
  end
  

end