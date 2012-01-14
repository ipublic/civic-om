require 'spec_helper'

describe Site do
  before(:all) do
    @authority = LinkedData::Authority.get THIS_AUTHORITY_ID
    @term = @authority.term
    @label = @authority.label

    @site_id = "site_dc"
  end
  
  describe "Initialization" do
    it 'should fail without an authority parameter' do
      @s = Site.new
      @s.should_not be_valid
      @s.errors[:term].should_not be_nil
      @s.errors[:authority].should_not be_nil
      lambda { @s.create! }.should raise_error
    end

    it 'should save properties and generate an identifier correctly' do
      @site = Site.new(:authority => @authority, :term => @term, :label => @label)
      @res = @site.save
      
      @db_site = Site.get(@res.id)
      @db_site.authority.should == @site.authority 
    end
    
    it 'should fail if site with same name already exists' do
      @dup_site = Site.new(:authority => @authority, :term => @term, :label => @label)
      lambda { @dup_site.save! }.should raise_error
    end
    
  end
  
  describe "Instance methods" do
    # describe ".public_database" do
    #   it "should provide a CouchDb database instance for this site" do
    #     @rtn_site = Site.get(@ns.authority)
    #     db = @rtn_site.public_database
    #     db.should be_a(CouchRest::Database)
    #     db.name.should == @db_name
    #   end
    # end
  end



end
