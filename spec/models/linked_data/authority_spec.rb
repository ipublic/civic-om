require 'spec_helper'

describe LinkedData::Authority do
  before(:all) do
    @uri = "example.gov"
    @term = "example_gov"
    @label = "My Home Town"
    @expected_id = ["authority", @term].join('_')
    @staging_db_name = "example_gov_staging"
    @public_db_name = "example_gov_public"
  end
  
  describe "Initialization" do
    it 'should fail without a term parameter' do
      lambda { Authority.create! }.should raise_error
    end

    it 'should save properties and generate an identifier correctly' do
      @authority = LinkedData::Authority.new(:uri => @uri, :term => @term, :label => @label)
      @saved_authority = @authority.save
      
      @saved_authority.term.should == @term
      @saved_authority.label.should == @label
      @saved_authority.id.should == @expected_id
    end
    
    it 'should find an Authority record by_term' do
      auth = LinkedData::Authority.by_term(:key => @term)
      auth.count.should == 1
      auth.first.term.should == @term
    end
    
    it 'should fail if site with same name already exists' do
      @dup_authority = LinkedData::Authority.new(:term => @term)
      lambda { @dup_authority.save! }.should raise_error
    end
  end  
  
  describe "Instance methods" do
    it 'should provide a staging database name and object' do
      @auth = LinkedData::Authority.get(@expected_id)
      
      @auth.staging_database_name.should == @staging_db_name
      @auth.staging_database.should be_a(CouchRest::Database)
    end
    
    it 'should provide a public database name and object' do
      @auth = LinkedData::Authority.get(@expected_id)
      
      @auth.public_database_name.should == @public_db_name
      @auth.public_database.should be_a(CouchRest::Database)
    end
  end
  
  
end
