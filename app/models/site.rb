require 'no_site_defined'

class Site < CouchRest::Model::Base

  DATABASES = [SITES_DATABASE.name, STAGING_DATABASE.name, VOCABULARIES_DATABASE.name]

  use_database SITES_DATABASE
  unique_id :authority

  property :name, String
  property :url, String
  property :public_couchhost, String
  property :authority, String, :read_only => true
  property :base_uri, String, :read_only => true

  timestamps!
  
  design do
    view :by_name
    view :by_authority
    view :by_base_uri
  end

  # Validations
  validates_presence_of :name
  validates_presence_of :url
  validates_presence_of :public_couchhost
  validates_uniqueness_of :authority, :view => 'all'

  before_create :init_site
  
  def public_database
    return if self.authority.nil?
    db_name = %W[#{COUCHDB_CONFIG[:db_prefix]} #{self.authority} #{COUCHDB_CONFIG[:db_suffix]}].select {|v| !v.blank?}.join('_')

    server = CouchRest.new(self.url)
    db = server.database!(db_name)
  end
  
  
private
  def init_site
    # self.url = "http://#{self.identifier}.#{OM_DOMAIN}#{OM_PORT == 80 ? '' : OM_PORT}"
    ns = Namespace.new(self.url)
    write_attribute(:authority, ns.authority)
    write_attribute(:base_uri, ns.base_uri)
  end
end