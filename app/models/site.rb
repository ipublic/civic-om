require 'no_site_defined'

class Site < CouchRest::Model::Base

  DATABASES = [SITES_DATABASE.name, STAGING_DATABASE.name, VOCABULARIES_DATABASE.name]

  use_database SITES_DATABASE
  unique_id :authority

  property :authority, String, :read_only => true
  property :base_uri, String
  property :url, String

  property :public_couchhost, String
  property :public_database, String

  timestamps!
  
  design do
    view :by_authority
    view :by_base_uri
  end

  # Validations
  validates_presence_of :url
  validates_uniqueness_of :authority, :view => 'all'

  before_create :init_site

  # def initialize(options={})
  #   super(options)
  #   self.url = options.delete(:url) {|key| raise ArgumentError, "you must provide a #{key} value"}
  #   set_props
  # end
  
  # def couch_db
  #   return if self.default_database.nil?
  #   Couch::Host.new(self.default_database)
  # end
  # 
  
private
  def init_site
    # self.url = "http://#{self.identifier}.#{OM_DOMAIN}#{OM_PORT == 80 ? '' : OM_PORT}"
    ns = Namespace.new(self.url)
    write_attribute(:authority, ns.authority)
    write_attribute(:base_uri, ns.base_uri)
    write_attribute(:public_couchhost, self.url)
    write_attribute(:public_database, ns.authority)
    
    server = CouchRest.new(self.url)
    db = server.database!(self.public_database)
  end
end