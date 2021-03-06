require 'spec_helper'

describe LinkedData::Topic do

  before(:all) do
    @topic_id = "topic_om_gov_dc_addresses"
    @topic_instance_db_name = "om_gov_dc_addresses"
        
    @authority = LinkedData::Authority.get THIS_AUTHORITY_ID
    
    @topic_term = "dc_addresses"
    @topic_label = "District of Columbia Addresses"

    # @address_vocab = LinkedData::Vocabulary.get("vocabulary_openmedia_dev_om_street_address")

    @design_doc_id = '_design/' + @topic_term.singularize.camelize

    @prop_names = %W(formatted_address)
    @key_props  = %W(city state)
    @all_props = @prop_names + @key_props
    @prop_list = @prop_names.inject([]) {|memo, name| memo << LinkedData::Property.new(:term => name)}
    @prop_list = @key_props.inject(@prop_list) {|memo, name| memo << LinkedData::Property.new(:term => name, :key => true)}

    @vocab = LinkedData::Vocabulary.create!(:authority => @authority,
                                            :term => "street_address",
                                            :label => "Street address",
                                            :property_delimiter => "#",
                                            :curie_prefix => "addr",
                                            :properties => @prop_list
                                            )
    
    @topic = LinkedData::Topic.new(:authority => @authority, 
                                    :term => @topic_term, 
                                    :label => @topic_label,
                                    :vocabulary => @vocab,
                                    :comment => "Site addresses"
                                    )
  end

  after(:all) do
    db = COUCHDB_SERVER.database(@topic_instance_db_name)
    db.delete! rescue nil
  end

  describe "initialization" do
    it 'should fail to initialize instance without term and authority properties' do
      @topic = LinkedData::Topic.new
      @topic.should_not be_valid
      @topic.errors[:term].should_not be_nil
      @topic.errors[:authority].should_not be_nil
    end
    
    it 'should fail to create an instance database unless topic is valid and saved' do
      @topic.instance_database.should be_nil
    end
    
    it 'should save and generate an identifier correctly' do
      lambda { @topic.save! }.should_not raise_error
      saved_topic = LinkedData::Topic.by_term(:key => @topic_term)
      saved_topic.rows.first.id.should == @topic_id
    end
    
    it 'should provide a valid CouchDB database to store instance docs' do
      @topic.instance_database.should be_a(::CouchRest::Database)
      @topic.instance_database_name.should == @topic_instance_db_name
    end
    
    it "should automatically add views for Vocabulary property keys" do
      @topic.instance_design_doc.has_view?("by_city").should == true
      @topic.instance_design_doc.has_view?("by_state").should == true
    end
  end
  
  describe "vocabulary" do
    it "should provide a list of properties from associated vocabulary" do
      @topic.vocabulary.properties.each {|p| @all_props.include?(p.term).should == true}
    end
    
    it "should provide a list of types from associated vocabulary" do
    end
  end
  
  describe "instance methods" do
    before(:all) do
      @model = @topic.couchrest_model
      @model_name = @topic_term.camelize.singularize
      @sn = "abc123"
      @doc = @topic.new_instance_doc(:formatted_address =>"1600 Pennsylvania Ave", 
                                      :city =>"Washington", :state =>"DC", :serial_number => @sn)
      @resp = @topic.instance_database.save_doc @doc
      @saved_doc = @topic.instance_database.get @resp['id']
    end
    
    describe ".instance_database" do
      it "should provide a CouchDb database" do
        db = @topic.instance_database
        db.should be_a(::CouchRest::Database)
        db.name.should == @topic_instance_db_name
      end
    end
    
    describe ".instance_design_doc" do
      it 'should create an associated CouchRest::Design document' do
        # dsn = @doc.design_doc
        dsn = @topic.instance_design_doc
        dsn.should be_a(::CouchRest::Design)
        dsn.name.should == @topic_term.singularize.camelize
        dsn["_id"].should == @design_doc_id
        dsn.has_view?(:all).should be_true
      end

      it "should be able to add a view definition" do
        dsn = @topic.instance_design_doc
        lambda{dsn.view @sn_prop_name.to_sym}.should raise_error
        dsn.view_by :serial_number 
        dsn.save
        @topic.instance_design_doc.has_view?("by_serial_number").should == true
      end
    end
    
    describe ".couchrest_model" do
      it "should provide a CouchRest model for the Topic" do
        @model.name.should == @model_name
        @model.superclass.to_s.should == "CouchRest::Model::Base"
      end

      it "should point to the instance database to store docs" do
        @model.database.name.should == @topic_instance_db_name
      end
    end
    
    describe ".new_instance_doc" do
      it "should set the documents model_type_key" do
        @doc['model'].should == @topic_term.camelize.singularize
      end

      it "should initialize properties and save an instance doc correctly" do
        @saved_doc.id.should_not be_nil
        @saved_doc['formatted_address'].should == "1600 Pennsylvania Ave"
        @saved_doc['city'].should == "Washington"
        @saved_doc['state'].should == "DC"
        @saved_doc['serial_number'].should == @sn
      end

      it "should find all instances for this Topic's model" do
        elwood_blues = @topic.new_instance_doc(:formatted_address => "1060 West Addison Street", 
                                               :city =>"Chicago", :state =>"IL", :serial_number => @sn).save
        addr_docs = @topic.instance_design_doc.view(:all)
        addr_docs['total_rows'].should == 2
        saved_doc = @topic.instance_database.get addr_docs['rows'].first['id']
        saved_doc['city'].should == "Chicago"
      end
    end
    
    describe ".destroy_instance_docs!" do
      it "should delete all Topic data documents in instance db" do
        
        ## This spec requires CouchDB configuration delayed_commits = false
        lambda {@topic.instance_database.get @resp['id']}.should_not raise_error
        ct = @topic.destroy_instance_docs!
        ct.should == 2
        lambda {@topic.instance_database.get @resp['id']}.should raise_error
      end
    end

    describe ".load_instance_docs" do
      it "should store a collection of documents" do
        docs = []
        %W[animal vegetable mineral person place thing].each {|i| docs << @topic.new_instance_doc(:classification => i)}
        @res = @topic.load_instance_docs(docs)
        @res.should == 6
        @topic.docs_read.should == @topic.docs_written
      end
    end
    
    describe ".record_count" do
      it "should return number of Topic instance documents" do
        @topic.record_count.should == 6
      end
    end
    
    
  end
  

end