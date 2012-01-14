require 'spec_helper'

describe LinkedData::Authority do
  before(:all) do
    @uri = "example.gov"
    @term = "example_gov"
    @label = "My Home Town"
    @expected_id = ["authority", @term].join('_')
  end
  
  describe "Initialization" do
    it 'should fail without a term parameter' do
      lambda { Authority.create! }.should raise_error
    end

    it 'should save properties and generate an identifier correctly' do
      @authority = LinkedData::Authority.new(:uri => @uri, :term => @term, :label => @label)
      @saved_authority = @authority.save
      
      @saved_authority.term.should == @term
      @saved_authority.label.should == @label
      @saved_authority.id.should == @expected_id
    end
    
    it 'should find an Authority record by_term' do
      auth = LinkedData::Authority.by_term(:key => @term)
      auth.count.should == 1
      auth.first.term.should == @term
    end
    
    it 'should fail if site with same name already exists' do
      @dup_authority = LinkedData::Authority.new(:term => @term)
      lambda { @dup_authority.save! }.should raise_error
    end
  end  
  
end
