require 'spec_helper'

describe Topic do

  before(:each) do
    SCHEMA_DATABASE.recreate! rescue nil

    @authority = Authority.get THIS_AUTHORITY_ID

    @col_label = "Education"
    @term = "education"
    @label = "Reading Proficiency-Third Grade"

    @prop_names = %W(enrollment)
    @key_props  = %W(school_name city)
    @all_props = @prop_names + @key_props
    @prop_list = @prop_names.inject([]) {|memo, name| memo << Property.new(:term => name)}
    @prop_list = @key_props.inject(@prop_list) {|memo, name| memo << Property.new(:term => name, :key => true)}
    
    @collection = Collection.create!(:term => @term,
                                     :label => @col_label, 
                                     :authority => @authority,
                                     :tags=>["schools", "teachers", "students"], 
                                     :comment => "Matters associated with public schools")
    
    @topic = Topic.new(:label => @col_label,
                            :term => @term,
                            :authority => @authority,
                            :properties => @prop_list,
                            :tags => ["reading", "testing", "third grade"], 
                            :comment => "Percentage of children in third grade who read on grade level")
                            
    @topic_uri = "http://civicopenmedia.us/dcgov/topics/education"
    @topic_id = "topic_om_gov_education"
  end
  
  describe "class methods" do
    describe "initialization" do
      it 'should fail to initialize instance without a term, authority and base_uri' do
        @t = Topic.new
        @t.should_not be_valid
        @t.errors[:term].should_not be_nil
        @t.errors[:authority].should_not be_nil
        @t.errors[:base_uri].should_not be_nil
        lambda { Topic.create!(:base_uri => @base_uri, :term => "percent_promoted", :authority => @authority) }.should_not raise_error
      end

      it 'should save and generate an identifier correctly' do
        lambda { @topic.save! }.should change(Topic, :count).by(1)
        @res = Topic.get(@topic_id)
        @res = Topic.first
        @res.id.should == @topic_id
      end
    end
    
    describe ".key_list" do
      it 'should provide an array of Property Key names' do
        @key_props.should ==  @topic.key_list
      end
    end
    
    describe ".enumerations" do
      it "should save and retreive dictionaries by property name" do
        @topic.enumerations = @topic.enumerations.merge({
            "clowns" => {"c" => "circus", "r" => "rodeo"}, 
            "categories" => {"a" => "animal", "v" => "vegetable", "m" => "mineral"}, 
            "dogs" => {"l" => "lab", "g" => "german shepard"}
            })
        # @topic.save!
        # @v = Topic.get(@topic_id)

        @topic.enumerations["clowns"]["r"].should == "rodeo"
        @topic.enumerations["categories"]["m"].should == "mineral"

        @topic.enumerations = @topic.enumerations.merge({
            "categories" => {"a" => "animal", "v" => "vegetable", "m" => "margarine"} 
            })
        @topic.enumerations["clowns"]["r"].should == "rodeo"
        @topic.enumerations["categories"]["m"].should == "margarine"
      end
    end
    
    describe ".decode" do
      it "should return lookup value for provided property and key" do
        @topic.enumerations = @topic.enumerations.merge({
            "clowns" => {"c" => "circus", "r" => "rodeo"}, 
            "categories" => {"a" => "animal", "v" => "vegetable", "m" => "mineral"}, 
            "dogs" => {"l" => "lab", "g" => "german shepard"}
            })
          
        @topic.decode("clowns", "c").should == "circus"
      end
    end
  end
  
  describe "URIs" do
    it 'should recognize a local topic and generate correct URI' do
      lcl_topic = Topic.create!(:label => "LocalTopic",
                                 :term => "LocalTopic",
                                 :base_uri => @base_uri, 
                                 :authority => @authority,
                                 :curie_prefix => "om",
                                 :comment => "Datatypes defined on local OM site"
                                 )
                                                
      topic = Topic.get(lcl_topic.id)
      topic.id.should == "topic_om_gov_localtopic"
    end
  
    it 'should recognize an external vocabulary and generate correct URI' do
      xsd_topic = Topic.create!(:label => "XMLSchema",
                                                    :term => "XMLSchema",
                                                    :base_uri => "http://www.w3.org/2001", 
                                                    :authority => @authority,
                                                    :curie_prefix => "xsd",
                                                    :comment => "Datatypes defined in XML schemas"
                                                    )
                                                
      topic = Topic.get(xsd_topic.id)
      topic.id.should == "topic_om_gov_xmlschema"
    end

  end

  it 'should return this Topic when searching by Collection' do
  end

  describe "Views" do
    it 'should use tags view to return matching docs' do
      @topic.save!
      @res = Topic.tag_list(:key => "xyxyxy")
      @res.length.should == 0 
      @res = Topic.tag_list(:key => "testing")
      @res.rows.length > 0
      @res.rows.first.id.should == @topic_id
    end
  end

  # it "should use has_geometry view to return matching docs" do
  #   @topic.save!
  #   @res = Topic.by_has_geometry.length.should == 0
  #   @topic.geometries << GeoJson::Point.new(GeoJson::Position.new([30, 60]))
  #   @topic.save!
  #   @res = Topic.by_has_geometry.length.should == 1
  # end

  # describe 'metadata repository' do
  #   it 'should return its metadata rdf repo (and create couch db if necessary)' do
  #     @site.metadata_repository.should == "#{@site.identifier}_metadata"
  #   end
  # end

end
