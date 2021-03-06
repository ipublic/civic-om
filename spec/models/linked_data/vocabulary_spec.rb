require 'spec_helper'

describe LinkedData::Vocabulary do

  before(:each) do
    SCHEMA_DATABASE.recreate! rescue nil

    @authority = LinkedData::Authority.get THIS_AUTHORITY_ID

    @col_label = "Education"
    @term = "education"
    @label = "Reading Proficiency-Third Grade"

    @prop_names = %W(enrollment)
    @key_props  = %W(school_name city)
    @all_props = @prop_names + @key_props
    @prop_list = @prop_names.inject([]) {|memo, name| memo << LinkedData::Property.new(:term => name)}
    @prop_list = @key_props.inject(@prop_list) {|memo, name| memo << LinkedData::Property.new(:term => name, :key => true)}
    
    @collection = LinkedData::Collection.create!(:term => @term,
                                                 :label => @col_label, 
                                                 :authority => @authority,
                                                 :tags=>["schools", "teachers", "students"], 
                                                 :comment => "Matters associated with public schools")
    
    @vocabulary = LinkedData::Vocabulary.new(:label => @col_label,
                            :term => @term,
                            :authority => @authority,
                            :properties => @prop_list,
                            :tags => ["reading", "testing", "third grade"], 
                            :comment => "Percentage of children in third grade who read on grade level")
                            
    @vocab_uri = "http://civicopenmedia.us/dcgov/vocabularies/education"
    @vocab_id = "vocabulary_om_gov_education"
  end
  
  describe "class methods" do
    describe "initialization" do
      it 'should fail to initialize instance without a term, authority and base_uri' do
        @v = LinkedData::Vocabulary.new
        @v.should_not be_valid
        @v.errors[:term].should_not be_nil
        @v.errors[:authority].should_not be_nil
        @v.errors[:base_uri].should_not be_nil
        lambda { LinkedData::Vocabulary.create!(:base_uri => @base_uri, :term => "percent_promoted", :authority => @authority) }.should_not raise_error
      end

      it 'should save and generate an identifier correctly' do
        lambda { @vocabulary.save! }.should change(LinkedData::Vocabulary, :count).by(1)
        @res = LinkedData::Vocabulary.get(@vocab_id)
        @res = LinkedData::Vocabulary.first
        @res.id.should == @vocab_id
      end
    end
    
    describe ".key_list" do
      it 'should provide an array of Property Key names' do
        @key_props.should ==  @vocabulary.key_list
      end
    end
    
    describe ".enumerations" do
      it "should save and retreive dictionaries by property name" do
        @vocabulary.enumerations = @vocabulary.enumerations.merge({
            "clowns" => {"c" => "circus", "r" => "rodeo"}, 
            "categories" => {"a" => "animal", "v" => "vegetable", "m" => "mineral"}, 
            "dogs" => {"l" => "lab", "g" => "german shepard"}
            })
        # @vocabulary.save!
        # @v = LinkedData::Vocabulary.get(@vocab_id)

        @vocabulary.enumerations["clowns"]["r"].should == "rodeo"
        @vocabulary.enumerations["categories"]["m"].should == "mineral"

        @vocabulary.enumerations = @vocabulary.enumerations.merge({
            "categories" => {"a" => "animal", "v" => "vegetable", "m" => "margarine"} 
            })
        @vocabulary.enumerations["clowns"]["r"].should == "rodeo"
        @vocabulary.enumerations["categories"]["m"].should == "margarine"
      end
    end
    
    describe ".decode" do
      it "should return lookup value for provided property and key" do
        @vocabulary.enumerations = @vocabulary.enumerations.merge({
            "clowns" => {"c" => "circus", "r" => "rodeo"}, 
            "categories" => {"a" => "animal", "v" => "vegetable", "m" => "mineral"}, 
            "dogs" => {"l" => "lab", "g" => "german shepard"}
            })
          
        @vocabulary.decode("clowns", "c").should == "circus"
      end
    end
  end
  
  describe "URIs" do
    it 'should recognize a local vocabulary and generate correct URI' do
      lcl_vocab = LinkedData::Vocabulary.create!(:label => "LocalVocabulary",
                                                   :term => "LocalVocabulary",
                                                   :base_uri => @base_uri, 
                                                   :authority => @authority,
                                                   :curie_prefix => "om",
                                                   :comment => "Datatypes defined on local OM site"
                                                   )
                                                
      vocab = LinkedData::Vocabulary.get(lcl_vocab.id)
      vocab.id.should == "vocabulary_om_gov_localvocabulary"
    end
  
    it 'should recognize an external vocabulary and generate correct URI' do
      xsd_vocab = LinkedData::Vocabulary.create!(:label => "XMLSchema",
                                                    :term => "XMLSchema",
                                                    :base_uri => "http://www.w3.org/2001", 
                                                    :authority => @authority,
                                                    :curie_prefix => "xsd",
                                                    :comment => "Datatypes defined in XML schemas"
                                                    )
                                                
      vocab = LinkedData::Vocabulary.get(xsd_vocab.id)
      vocab.id.should == "vocabulary_om_gov_xmlschema"
    end

  end

  it 'should return this Vocabulary when searching by Collection' do
  end

  describe "Views" do
    it 'should use tags view to return matching docs' do
      @vocabulary.save!
      @res = LinkedData::Vocabulary.tag_list(:key => "xyxyxy")
      @res.length.should == 0 
      @res = LinkedData::Vocabulary.tag_list(:key => "testing")
      @res.rows.first.id.should == @vocab_id
    end
  end

  # it "should use has_geometry view to return matching docs" do
  #   @vocabulary.save!
  #   @res = LinkedData::Vocabulary.by_has_geometry.length.should == 0
  #   @vocabulary.geometries << GeoJson::Point.new(GeoJson::Position.new([30, 60]))
  #   @vocabulary.save!
  #   @res = LinkedData::Vocabulary.by_has_geometry.length.should == 1
  # end

  # describe 'metadata repository' do
  #   it 'should return its metadata rdf repo (and create couch db if necessary)' do
  #     @site.metadata_repository.should == "#{@site.identifier}_metadata"
  #   end
  # end

end
