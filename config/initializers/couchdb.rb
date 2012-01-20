begin
  env = ENV['RAILS_ENV'] || 'development'
  couchdb_config = YAML::load(ERB.new(IO.read(Rails.root.to_s + "/config/couchdb.yml")).result)[env]

  protocol  = couchdb_config["protocol"]  || 'http'
  host      = couchdb_config["host"]      || 'localhost'
  port      = couchdb_config["port"]      || '5984'
  database  = couchdb_config["database"] || ''
  db_prefix = couchdb_config["prefix"] || ""
  db_suffix = couchdb_config["suffix"] || ""
  username  = couchdb_config["username"]
  password  = couchdb_config["password"]

rescue
  raise "There was a problem with your config/couchdb.yml file. Check and make sure it's present and the syntax is correct."

else

  authorized_host = (username.blank? && password.blank?) ? host : "#{CGI.escape(username)}:#{CGI.escape(password)}@#{host}"

  COUCHDB_CONFIG = {
    :host_path => "#{protocol}://#{authorized_host}:#{port}",
    :db_prefix => "#{db_prefix}",
    :db_suffix => "#{db_suffix}"
  }

  # server = CouchRest::Server.new([protocol, authorized_host, ":", port].join)
  # COUCHDB_SERVER = CouchRest.new COUCHDB_CONFIG[:host_path]

  COUCHDB_SERVER = CouchRest::Server.new(COUCHDB_CONFIG[:host_path])

  SITES_DATABASE = COUCHDB_SERVER.database!(%W[#{db_prefix} sites #{db_suffix}].select {|v| !v.blank?}.join("_"))
  # STAGING_DATABASE = COUCHDB_SERVER.database!(%W[#{db_prefix} staging #{db_suffix}].select {|v| !v.blank?}.join("_"))
  SCHEMA_DATABASE = COUCHDB_SERVER.database!(%W[#{db_prefix} schema #{db_suffix}].select {|v| !v.blank?}.join("_"))
end

CouchRest::Model::Base.configure do |config|
  # config.mass_assign_any_attribute = true

  config.model_type_key = 'model'
end

