require 'spec_helper'

describe LinkedData::Type do
  before(:each) do
    SCHEMA_DATABASE.recreate! rescue nil

    @authority = LinkedData::Authority.get THIS_AUTHORITY_ID
    @vocab_label = "Crime"
    
    @str_uri = 'http://www.w3c.org/2001/XMLSchema#string'
    @int_uri = 'http://www.w3c.org/2001/XMLSchema#integer'
    @col_label = "Public Safety"
    
    
    @crime = LinkedData::Vocabulary.create!(:authority => @authority,
                                            :label => @vocab_label,
                                            :term => @vocab_label, 
                                            :property_delimiter => "#"
                                            )


    @xsd = ::LinkedData::Vocabulary.create!(:authority => @authority,
                                            :base_uri => "http://www.w3.org/2001/XMLSchema", 
                                            :label => "XMLSchema",
                                            :term => "XMLSchema",
                                            :property_delimiter => "#",
                                            :curie_prefix => "xsd",
                                            :comment => "Datatypes defined in XML schemas"
                                            )

    @str = LinkedData::Type.create!(:authority => @authority, :vocabulary => @xsd, :term => "string")

    @int_id = "type_om_gov_integer"

  end
  
  it 'should fail to initialize instance without term and vocabulary' do
    @ldt = LinkedData::DataSource.new
    @ldt.should_not be_valid
    @ldt.errors[:term].should_not be_nil
    @ldt.errors[:authority].should_not be_nil
    @ldt.errors[:vocabulary].should_not be_nil
    lambda { LinkedData::Type.create!(:authority => @authority, :vocabulary => @crime, :term => "integer") }.should_not raise_error
  end
  
  it 'should save and generate an identifier correctly' do
    term = "integer"
    int = LinkedData::Type.new(:authority => @authority, :vocabulary => @xsd, :term => term)

    lambda { int.save! }.should change(LinkedData::Type, :count).by(1)
    @res = LinkedData::Type.get(int.id)
    @res.id.should == @int_id
    @res.authority.should == @xsd.authority
  end
  
  it 'should return this Type when searching by Vocabulary' do
    term = "integer"
    int = LinkedData::Type.create!(:authority => @authority, :vocabulary => @xsd, :term => term)

    @types = LinkedData::Type.find_by_vocabulary_id(@xsd.id)
    @types.rows.first.id.should == @int_id
  end
  
  it 'should use tags view to return matching docs' do
    term = "integer"
    int = LinkedData::Type.create!(:authority => @authority, :vocabulary => @xsd, :term => term, :tags => ["core", "intrinsic"])

    int.save!
    @res = LinkedData::Type.tag_list(:key => "xyxyxy")
    @res.length.should == 0 
    @res = LinkedData::Type.tag_list(:key => "intrinsic")
    @res.rows.first.id.should == @int_id
  end
  
  it 'should save and return an external vocabulary and Type' do
    @type = LinkedData::Type.create!(:authority => @authority, :vocabulary => @xsd, :term => "long")
    # @type.public_uri.should == "http://www.w3.org/2001/XMLSchema#long"
    @type.compound?.should == false
  end
  
  it 'should save and return a Compound Type' do 
    cr = LinkedData::Type.new(:authority => @authority,
                              :vocabulary => @crime, 
                              :label => "Crime Reports",
                              :term => "crime_reports"
                              )
    
    method = LinkedData::Property.new(:term => "Method", :expected_type => @str_uri)
    offense = LinkedData::Property.new(:term => "Offense", :expected_type => @str_uri)
    cr.properties << method << offense
    comp = cr.save

    res = LinkedData::Type.get(comp.id)
    res.properties.first.term.should == "Method"
    res.properties.first.expected_type.should == @str_uri
    res.compound?.should == true
  end
  
    
end
