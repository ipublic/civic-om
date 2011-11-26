require 'spec_helper'

describe ETL::OpenMedia::ControlFile do

  before(:all) do
    @ns = Namespace.new("http://dcgov.civicopenmedia.us")
    @authority = @ns.authority
    @term = "crime_file"
    @cf = ETL::OpenMedia::ControlFile.new
    @id = "controlfile_civicopenmedia_us_dcgov_crime_file"
  end

  describe "initialization" do
    it 'should not save without presence of term property' do
      lambda { @cf.save! }.should raise_error
      @cf.term = @term
    end
    
    it 'should not save without presence of authority property' do
      lambda { @cf.save! }.should raise_error
      @cf.authority = @authority
    end
    
    it 'should save and retrieve from couchdb' do
      @res = @cf.save
      @res.id.should == @id
      
      saved_cf = ETL::OpenMedia::ControlFile.find(@id)
      saved_cf.authority.should == @authority
      saved_cf.term.should == @term
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
        @parser = :fixed_width
        @parser_value = "Fixed Width"
        list = @cf.parser_list
        list[@parser].should == @parser_value
      end
    end
    
    describe "write" do
      it "should save a properly formatted activewarehouse-etl control file" do
        @cf_out_tst = File.join(Dir.tmpdir, @authority, "#{@term}_tst.ctl")
        @cf.write(@cf_out_tst)
        File.exists?(@cf_out_tst).should == true
      end
    end
  end
  
  describe "Extract" do
    it 'should parse a CSV file and return contents as a hash of rows' do
      @data_in_file = File.join('/Users/dthomas/dev/ror/civic-om', "spec/fixtures/crime_incidents_current.csv")
      @cf_out_csv = File.join(Dir.tmpdir, @authority, "#{@term}_csv.ctl")

      @parser = :csv
      @source_parameters = {:skip_lines => 1}
      # @definition = [:first_name, :last_name. :email]
      # @parser_options = ETL::OpenMedia::Parser::CsvOptions.new  # will pass default values

      @cf_csv = ETL::OpenMedia::ControlFile.new(:authority => @authority,
                                                :term => @term,
                                                :source_file => @data_in_file,
                                                :parser => @parser,
                                                # :definition => @definition,
                                                :source_parameters => @source_parameters
                                                )

      @cf_csv.write(@cf_out_csv)
      rows = @cf_csv.extract(@cf_out_csv)
      rows.count.should == 304
    end
    
    it 'should parse an Excel file and return contents as a hash of rows' do
      @data_in_file = File.join('/Users/dthomas/dev/ror/civic-om', "spec", "fixtures", "mi_scorecard.xls")
      @cf_out_xls = File.join(Dir.tmpdir, @authority, "#{@term}_xls.ctl")

      @parser = :excel
      @source_parameters = {:skip_lines => 1}
      @fields = %W[year	percentage_unemployed	gdp_growth	deficient_bridges	personal_per_capita_income	children_in_poverty	infant_mortality	population_obesity	reading_capability_third_grade	college_readiness	degreed_popopulation	bond_rating	govt_debt_burden_per_capita	govt_operating_cost_mi	govt_operating_cost_oh	govt_operating_cost_wa	govt_operating_cost_va	state_services_online	state_park_popularity	population_change_25_to_34	surface_water_quality	violent_crime_rates	property_crime_rates	traffic_injuries_fatal	traffic_injuries_serious_and_fatal]
      
      @definition = {:ignore_blank_line => true, :fields => @fields.map {|f| f.to_sym}}
      # @parser_options = ETL::OpenMedia::Parser::ExcelOptions.new  # will pass default values

      @cf_xls = ETL::OpenMedia::ControlFile.new(:authority => @authority,
                                                :term => @term,
                                                :source_file => @data_in_file,
                                                :parser => @parser,
                                                :definition => @definition,
                                                :source_parameters => @source_parameters
                                                )

      @cf_xls.write(@cf_out_xls)
      rows = @cf_xls.extract(@cf_out_xls)
      rows.count.should == 11
      rows[2][:percentage_unemployed].to_f.should == 0.062
    end
    
    it 'should parse a Shapefile and return contents as a hash of rows' do
      @cf_out_shp = File.join(Dir.tmpdir, @authority, "#{@term}_shp.ctl")
    end
    
  end

end