require 'no_site_defined'

class Site < CouchRest::Model::Base
  DATABASES = [SITES_DATABASE.name, STAGING_DATABASE.name, SCHEMA_DATABASE.name]
  use_database SITES_DATABASE
  unique_id :identifier
  
  belongs_to :authority, :class_name => "LinkedData::Authority"
  belongs_to :administrator_contact, :class_name => "Vocabularies::VCard::Base"

  property :identifier, String, :read_only => true
  property :term, String
  property :label, String
  property :tag_line, String
  property :terms_of_use, String
  timestamps!
  
  # Validations
  validates_presence_of :authority
  validates_presence_of :label

  ## Callbacks
  before_create :init_site
  
  design do
    view :by_authority_id
  end

  def public_database
    return if self.authority.nil?
    db_name = %W[#{COUCHDB_CONFIG[:db_prefix]} #{self.authority} #{COUCHDB_CONFIG[:db_suffix]}].select {|v| !v.blank?}.join('_')

    server = CouchRest.new(self.url)
    db = server.database!(db_name)
  end
  
  def terms_of_use_del
    self.terms_of_use ||= "By using data made available through this site the user agrees to all the conditions stated in the following paragraphs: This agency makes no claims as to the completeness, accuracy or content of any data contained in this application; makes any representation of any kind, including, but not limited to, warranty of the accuracy or fitness for a particular use; nor are any such warranties to be implied or inferred with respect to the information or data furnished herein. The data is subject to change as modifications and updates are complete. It is understood that the information obtained from this site is being used at one's own risk. These Terms of Use govern any use of this service and may be changed at any time, without notice by the sponsor agency."
  end
  
private
  def init_site
    class_basename = self.class.to_s.demodulize.downcase
    write_attribute(:identifier,  %W[#{class_basename} #{self.term}].join('_'))
    # write_attribute(:authority, "civicopenmedia_us_#{self.term}")
    
    # # self.url = "http://#{self.identifier}.#{OM_DOMAIN}#{OM_PORT == 80 ? '' : OM_PORT}"
    # ns = Namespace.new(self.url)
    # write_attribute(:base_uri, ns.base_uri)
  end
end