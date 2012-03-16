require 'spec_helper'

describe Authority do
  before(:all) do
    @uri = "example.gov"
    @label = "My Home Town"

    @expected_staging_db_name = "civic_om_example_gov_staging_test"
    @expected_term = "example_gov"
    @expected_uri_string = "http://civicopenmedia.us/example_gov"
  end
  
  describe "Initialization" do
    it 'should fail without a site_domain parameter' do
      lambda { Authority.create! }.should raise_error
    end

    it 'should save properties and generate an identifier correctly' do
      @authority = Authority.new(:site_domain => @uri, :label => @label)
      @saved_authority = @authority.save
      
      @saved_authority.label.should == @label
      @saved_authority.id.should == @expected_term
      @saved_authority.term.should == @expected_term
    end
    
    it 'should find an Authority record by_term' do
      auth = Authority.by_term(:key => @expected_term)
      auth.count.should == 1
      auth.first.term.should == @expected_term
    end
    
    it 'should fail if site with same name already exists' do
      @dup_authority = Authority.new(:site_domain => @uri)
      lambda { @dup_authority.save! }.should raise_error
    end
  end  
  
  describe "Instance methods" do
    it 'should provide a staging database name and object' do
      @auth = Authority.get(@expected_term)
      
      @auth.proxy_database.name.should == @expected_staging_db_name
      @auth.proxy_database.should be_a(CouchRest::Database)
    end
    
    it 'should provide a uri_string' do
      @auth = Authority.get(@expected_term)
      @auth.uri_string.should == @expected_uri_string
    end
  end
  
  
end
