require 'spec_helper'

describe Site do
  before(:all) do
    host = COUCHDB_CONFIG[:host_path]
    name = "OpenMedia"
    @url = "http://dcgov.civicopenmedia.us"
    @site = Site.new(:url => @url, :name => name, :public_couchhost => host)
    @ns = Namespace.new(@url)
    @db_name = "om_civicopenmedia_us_dcgov_test"
  end
  
  describe "Initialization" do
    it 'should fail without a url parameter' do
      lambda { Site.create! }.should raise_error
    end

    it 'should save properties and generate an identifier correctly' do
      @saved_site = @site.save
      @saved_site.id.should == @ns.authority
      @saved_site.base_uri.should == @ns.base_uri
    end
    
    it 'should fail if site with same name already exists' do
      @dup_site = Site.new(:url => @url)
      lambda { @dup_site.save! }.should raise_error
    end
    
  end
  
  describe "Instance methods" do
    describe ".public_database" do
      it "should provide a CouchDb database instance for this site" do
        @rtn_site = Site.get(@ns.authority)
        db = @rtn_site.public_database
        db.should be_a(CouchRest::Database)
        db.name.should == @db_name
      end
    end
  end



end
