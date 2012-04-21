require 'spec_helper'

describe LinkedData::DataSource do
  before(:all) do
    @authority = LinkedData::Authority.get THIS_AUTHORITY_ID
    @site = Site.by_authority_id(:key => @authority.id).first
    @site.staging_database.recreate! rescue nil

    @data_source_term = "reported_crimes"
    @ds = LinkedData::DataSource.new(:authority => @authority, :term => @data_source_term)

    @ds_id = "data_source_om_gov_reported_crimes"
  end

  describe "initialization" do
    it 'should fail to initialize instance without term and authority properties' do
      @ds = LinkedData::DataSource.new
      @ds.should_not be_valid
      @ds.errors[:term].should_not be_nil
      @ds.errors[:authority_id].should_not be_nil
    end

    it 'should save and generate an identifier correctly' do
      lambda { LinkedData::DataSource.create!(:authority => @authority, :term => @data_source_term) }.should change(LinkedData::DataSource, :count).by(1)
      saved_dp = LinkedData::DataSource.first
      saved_dp.authority.should == @authority
      saved_dp.term.should == @data_source_term      
    end
  end
  
  describe "class methods" do
  end
  
  describe "instance methods" do
  end

  describe "views" do
  end

end