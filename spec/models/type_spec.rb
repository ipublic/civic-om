require 'spec_helper'

describe Type do
  before(:each) do
    SCHEMA_DATABASE.recreate! rescue nil

    @authority = Authority.get THIS_AUTHORITY_ID
    @type_label = "Crime"
    
    @str_uri = 'http://www.w3c.org/2001/XMLSchema#string'
    @int_uri = 'http://www.w3c.org/2001/XMLSchema#integer'
    @col_label = "Public Safety"
    
    
    # @crime = Vocabulary.create!(:authority => @authority,
    #                             :label => @type_label,
    #                             :term => @type_label, 
    #                             :property_delimiter => "#"
    #                             )
    # 
    # 
    # @xsd = ::Vocabulary.create!(:authority => @authority,
    #                             :base_uri => "http://www.w3.org/2001/XMLSchema", 
    #                             :label => "XMLSchema",
    #                             :term => "XMLSchema",
    #                             :property_delimiter => "#",
    #                             :curie_prefix => "xsd",
    #                             :comment => "Datatypes defined in XML schemas"
    #                             )

    @str = Type.create!(:authority => @authority, :term => "string")

    @int_id = "om_gov_integer"

  end
  
  it 'should fail to initialize instance without term and authority' do
    @ldt = Type.new
    @ldt.should_not be_valid
    @ldt.errors[:term].should_not be_nil
    @ldt.errors[:authority].should_not be_nil
    lambda { Type.create!(:authority => @authority, :term => "integer") }.should_not raise_error
  end
  
  it 'should save and generate an identifier correctly' do
    term = "integer"
    int = Type.new(:authority => @authority, :term => term)

    lambda { int.save! }.should change(Type, :count).by(1)
    @res = Type.get(int.id)
    @res.id.should == @int_id
    @res.authority.should == @authority
  end
  
  # it 'should return this Type when searching by Vocabulary' do
  #   term = "integer"
  #   int = Type.create!(:authority => @authority, :term => term)
  # 
  #   @types = Type.find_by_vocabulary_id(@xsd.id)
  #   @types.rows.first.id.should == @int_id
  # end
  
  it 'should use tags view to return matching docs' do
    term = "integer"
    int = Type.create!(:authority => @authority, :term => term, :tags => ["core", "intrinsic"])

    int.save!
    @res = Type.tag_list(:key => "xyxyxy")
    @res.length.should == 0 
    @res = Type.tag_list(:key => "intrinsic")
    @res.rows.length > 0
    @res.rows.first.id.should == @int_id
  end
  
  it 'should save and return an external vocabulary and Type' do
    @type = Type.create!(:authority => @authority, :term => "long")
    # @type.public_uri.should == "http://www.w3.org/2001/XMLSchema#long"
    @type.compound?.should == false
  end
  
  it 'should save and return a Compound Type' do 
    cr = Type.new(:authority => @authority,
                  :label => "Crime Reports",
                  :term => "crime_reports"
                  )
    
    method = Property.new(:term => "Method", :expected_type => @str_uri)
    offense = Property.new(:term => "Offense", :expected_type => @str_uri)
    cr.properties << method << offense
    comp = cr.save

    res = Type.get(comp.id)
    res.properties.first.term.should == "Method"
    res.properties.first.expected_type.should == @str_uri
    res.compound?.should == true
  end
  
    
end
