require 'spec_helper'

describe Parser::ShapefileParser do

  before(:each) do
    @shapefile_name = File.join(fixture_path, 'FireStnPt.zip')
    @shapefile_column_list = %w(OBJECTID_1 OBJECTID NAME GIS_ID SSL ADDRESS PHONE BFC 
                                  AMBULANCE RESCSQUAD MEDICUNIT TRUCK SPECIALTY DETAIL TYPE 
                                  ENGINE BATTALION RENSTATUS AID REL_UNITS WEB_URL geometry)

    @parser = Parser::ShapefileParser.new(@shapefile_name)
  end
  
  describe "class methods" do
    describe ".properties" do
      before(:each) do
        @column_list = @parser.columns
      end
      
      it "should not return an empty property list" do
        @column_list.size.should == @shapefile_column_list.size
      end
      
      it "should return all property names as terms" do
        @column_list.each {|p| @shapefile_column_list.include?(p.term).should == true }
      end
    end
    
    describe ".records" do
      before(:each) do
        @record_list = @parser.records
      end
      
      it "should not return an empty array of records" do
        @record_list.size.should > 0
      end
      
      it "should return an array of OpenMedia:RawRecord type" do
        @record_list.first.is_a?(LinkedData::RawRecord).should == true
      end
    end
  end
  
end