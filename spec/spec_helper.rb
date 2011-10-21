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

def reset_test_db!
  [SITE_DATABASE, STAGING_DATABASE, VOCABULARIES_DATABASE].each { |db| db.recreate! rescue nil }
  # OpenMedia::Site.instance_variable_set(:@instance, nil)
end

def delete_test_db!
  [SITE_DATABASE, STAGING_DATABASE, VOCABULARIES_DATABASE].each { |db| db.delete! rescue nil }
end

