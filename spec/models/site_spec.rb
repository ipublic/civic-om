require 'spec_helper'

describe Site do
  before(:all) do
    @authority = LinkedData::Authority.get THIS_AUTHORITY_ID
    @label = @authority.label
    @term = @authority.term + '_spec'

    @site_id = "site_om_gov_spec"
  end
  
  describe "Initialization" do
    it 'should fail without an authority parameter' do
      @s = Site.new
      @s.should_not be_valid
      @s.errors[:label].should_not be_nil
      @s.errors[:authority].should_not be_nil
      lambda { @s.create! }.should raise_error
    end

    it 'should save properties and generate an identifier correctly' do
      @site = Site.new(:authority => @authority, :term => @term, :label => @label)
      @res = @site.save
      
      @res.id.should == @site_id
      @res.authority.should == @site.authority
    end
    
    it 'should fail if site with same name already exists' do
      @dup_site = Site.new(:authority => @authority, :term => @term, :label => @label)
      lambda { @dup_site.save! }.should raise_error
    end
    
  end
  
  describe "Instance methods" do
  end



end
