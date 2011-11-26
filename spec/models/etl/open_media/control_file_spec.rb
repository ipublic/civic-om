require 'spec_helper'

describe ETL::OpenMedia::ControlFile do

  before(:all) do
    @ns = Namespace.new("http://dcgov.civicopenmedia.us")
    @authority = @ns.authority
    @term = "crime_xml_file"
    @control_file  = File.join(Dir.tmpdir, @ns.authority, "#{@term}.ctl")
    @source_file = File.join(File.dirname(__FILE__), "spec/fixtures/crime_incidents_current.csv")
    @source_file = File.join('/Users/dthomas/dev/ror/civic-om', "spec/fixtures/crime_incidents_current.csv")
    @parser_key = "csv"
    @parser_value = "Csv Parser"
    @id = "controlfile_civicopenmedia_us_dcgov_crime_xml_file"
    
    @cf = ETL::OpenMedia::ControlFile.new(:source_file => @source_file, 
                                          :parser => @parser_key)
  end

  describe "initialization" do
    it 'should properly initialize properties' do
      @cf.source_file.should == @source_file
      @cf.parser.should == @parser_key
      @cf.parser_options.should be_a(Hash)
    end
    
    it 'should not save without presence of term property' do
      lambda { @cf.save! }.should raise_error
      @cf.term = @term
    end
    
    it 'should not save without presence of authority property' do
      lambda { @cf.save! }.should raise_error
      @cf.authority = @authority
    end
    
    it 'should save and retreive from couchdb' do
      @res = @cf.save
      @res.id.should == @id
      
      saved_cf = ETL::OpenMedia::ControlFile.find(@id)
      saved_cf.source_file.should == @source_file
      saved_cf.parser.should == @parser_key
      saved_cf.parser_options.should be_a(Hash)
    end
  end

  describe "class views" do
    it 'should retreive saved control file using views' do
      ETL::OpenMedia::ControlFile.respond_to?(:by_term).should == true
      ETL::OpenMedia::ControlFile.respond_to?(:by_label).should == true
      ETL::OpenMedia::ControlFile.respond_to?(:by_authority).should == true

      ETL::OpenMedia::ControlFile.by_authority.count.should == 1
      ETL::OpenMedia::ControlFile.by_authority.all.first.id.should == @id
    end
  end

  
  describe "class instance methods" do
    describe "parser_list" do
      it 'should provde a hash of available parsers' do
        list = @cf.parser_list
        list[@parser_key].should == @parser_value
      end
    end
    
    describe "write" do
      it "should save a properly formatted activewarehouse-etl control file" do
        @cf.write(@control_file)
        File.exists?(@control_file).should == true
      end
    end
  end
  
  describe "execute" do
    it 'should parse the file and return contents as a hash of rows' do
      control = ETL::Control::Control.resolve @control_file
      parser = ETL::Parser::CsvParser.new(control.sources.first)
      rows = parser.collect { |row| row }
      rows.count.should == 4
    end
  end

end