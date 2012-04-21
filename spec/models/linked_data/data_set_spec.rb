require 'spec_helper'

describe LinkedData::DataSet do

  before(:all) do
    @site.staging_database.recreate! rescue nil
    @authority = LinkedData::Authority.get THIS_AUTHORITY_ID
    @site = Site.by_authority_id(:key => @authority.id).first

    @data_source_term = "reported_crimes"
    @data_source = LinkedData::DataSource.create!(:authority => @authority, :term => @data_source_term)

    @csv_filename = File.join(fixture_path, 'crime_incidents_current.csv')
    @parser = Parser::CsvParser.new(@csv_filename, {:header_row => true})
  end

  describe "initialization" do
    it 'should fail to initialize instance without term and authority properties' do
      @ds = LinkedData::DataSet.new
      @ds.should_not be_valid
      @ds.errors[:data_source_id].should_not be_nil
    end

    it "should accept an array of LinkedData::Property for source data" do
      @ds = LinkedData::DataSet.new
      @ds.properties = @parser.columns
      @ds.properties.length.should == 22
      @ds.properties.first.should be_a(LinkedData::Property)
      @ds.properties.first.term.should == "NID"
    end
    
    it 'should save and generate an identifier correctly' do
      lambda { LinkedData::DataSet.create!(:data_source => @data_source) }.should change(LinkedData::DataSet, :count).by(1)
      saved_dp = LinkedData::DataSet.first
      saved_dp.data_source.should == @data_source
    end

    it 'should present a LinkedData::DataSet when searching by DataSource id' do
      ldds = LinkedData::DataSet.by_data_source_id(:key => @data_source.id)
      ldds.count.should == 1
      ldds.first.term.should == @ds_term  
      ldds.first.authority.should == @authority
    end
  end
  
  describe "class methods" do
    describe ".serial_number" do
      it "should generate a unique serial number using MD5 hash seeded by current time and random number" do
        LinkedData::DataSet.serial_number.should_not == LinkedData::DataSet.serial_number
      end
    end
  end
  
  describe "instance methods" do
    describe ".extract!" do
      it "should raise an error if DataSet doc isn't saved" do
        lambda{@ds.extract!(@parser.records)}.should raise_error
      end

      it "should store all parsed records in the Staging db" do
        # @ds.save
        saved_dp = LinkedData::DataSet.by_term(:key => @ds_term).first
        @stats = saved_dp.extract!(@parser.records)
        @stats.docs_written.should == 304
      end
    end
  end

  describe "views" do
    before(:all) do
      # STAGING_DATABASE.recreate! rescue nil
      SCHEMA_DATABASE.recreate! rescue nil

      @csv_ds = LinkedData::DataSet.create!(:data_source => @data_source)
      @csv_filename = File.join(fixture_path, 'crime_incidents_current.csv')
      @csv_parser = Parser::CsvParser.new(@csv_filename, {:header_row => true})
      @csv_stats = @csv_ds.extract!(@csv_parser.records)

      @shp_ds_term = "dc_fire_stations"
      @shp_ds = LinkedData::DataSet.create!(:data_source => @data_source)

      @shapefile_name = File.join(fixture_path, 'FireStnPt.zip')
      @shp_parser = Parser::ShapefileParser.new(@shapefile_name)
      @shp_stats = @shp_ds.extract!(@shp_parser.records)
    end

    it "should return accurate counts for RawRecord and each DataSet" do
      LinkedData::DataSet.all.length.should == 2
      # LinkedData::DataSet.raw_records.length.should == 339
      @csv_ds.raw_doc_count.should == 304
      @csv_ds.last_extract.length.should == 304
      @shp_ds.raw_doc_count.should == 35
    end

  end
end