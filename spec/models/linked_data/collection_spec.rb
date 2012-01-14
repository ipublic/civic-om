require 'spec_helper'

describe LinkedData::Collection do

  before(:each) do
    SCHEMA_DATABASE.recreate! rescue nil
    @authority = LinkedData::Authority.get THIS_AUTHORITY_ID

    @term = "education"
    @collection = LinkedData::Collection.new(:term => @term,
                                             :label => "Education", 
                                             :authority => @authority,
                                             :tags => ["schools", "teachers", "students"], 
                                             :comment => "Matters associated with public schools")
                                             
    @col_id = "collection_om_gov_education"
  end
  
  it 'should fail to initialize instance without a term and authority propoerties' do
    @v = LinkedData::Vocabulary.new
    @v.should_not be_valid
    @v.errors[:term].should_not be_nil
    @v.errors[:authority].should_not be_nil
    lambda { LinkedData::Collection.create!(:term => @term, :authority => @authority) }.should_not raise_error
raise_error
  end


  it 'should save and generate an identifier correctly' do
    lambda { @collection.save! }.should change(LinkedData::Collection, :count).by(1)
  end
  
  it 'should generate a Label view and return results correctly' do
    @res = @collection.save
    @cols = LinkedData::Collection.by_label(:key => @res.label)
    @cols.rows.first.id.should == @col_id
  end

  it 'should provide a view by authority' do
    @res = @collection.save
    @cols = LinkedData::Collection.by_authority_id(:key => @authority.id)
    @cols.count.should be > 0
  end
  
  it 'should use tags view to return matching docs' do
    @collection.save!
    @res = LinkedData::Collection.tag_list(:key => "fire")
    @res.length.should == 0 
    @res = LinkedData::Collection.tag_list(:key => "teachers")
    @res.rows.first.id.should == @col_id
  end

  # describe 'metadata repository' do
  #   it 'should return its metadata rdf repo (and create couch db if necessary)' do
  #     @site.metadata_repository.should == "#{@site.identifier}_metadata"
  #   end
  # end

end
