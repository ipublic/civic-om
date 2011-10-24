require 'spec_helper'

describe Site do
  before(:all) do
    @url = "http://localhost:5984"
    @ns = Namespace.new(@url)
    @site = Site.new(:url => @url)
  end
  
  describe "Initialization" do
    it 'should fail without a url parameter' do
      lambda { Site.create! }.should raise_error
    end

    it 'should save properties and generate an identifier correctly' do
      @saved_site = @site.save
      @saved_site.id.should == @site.authority
      @saved_site.base_uri.should == @ns.base_uri
    end
    
    it 'should create an associated Couch database for storing site content' do
      @rtn_site = Site.get(@site.authority)
      server = CouchRest.new(@rtn_site.public_couchhost)
      puts server.databases
      server.databases.include?(@rtn_site.public_database).should == true
    end
    
    it 'should fail if site with same name already exists' do
      @dup_site = Site.new(:url => @url)
      lambda { @dup_site.save! }.should raise_error
    end
    
  end



end
