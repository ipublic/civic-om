# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'
require 'capybara/rspec'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  THIS_AUTHORITY_ID = "authority_om_gov"
  THIS_SITE_ID = "civic_openmedia_us_om"
  THIS_SITE_DB_NAME = "om_civic_openmedia_us_om_test"
  THIS_SITE_DB = COUCHDB_SERVER.database!(THIS_SITE_DB_NAME)
  
  # == Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  config.mock_with :rspec

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = false

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false
  
  config.before(:all) do
    reset_test_db!
    init_site
    # TEST_SITE ||= create_test_site
  end

  config.after(:all) do
    delete_test_db!
    # cr = TEST_SERVER
    # test_dbs = cr.databases.select { |db| db =~ /^#{TESTDB}/ }
    # test_dbs.each do |db|
    #   cr.database(db).delete! rescue nil
    # end
  end
end

def init_site
  @label = "OpenMedia"
  @uri = "http://om.gov"
  @term = "om_gov"
  @authority = LinkedData::Authority.create!(:term => @term, 
                                             :label => @label,
                                             :uri => @uri)
  Site.create!(:authority => @authority, :label => @authority.label)
end

def reset_test_db!
  [SITES_DATABASE, SCHEMA_DATABASE].each { |db| db.recreate! rescue nil }
  # OpenMedia::Site.instance_variable_set(:@instance, nil)
end

def delete_test_db!
  [SITES_DATABASE, SCHEMA_DATABASE, THIS_SITE_DB].each { |db| db.delete! rescue nil }
end

