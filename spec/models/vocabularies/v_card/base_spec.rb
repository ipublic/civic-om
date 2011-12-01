require 'spec_helper'

describe Vocabularies::VCard do
  describe 'Initialization' do
    before(:each) do
      @vc = Vocabularies::VCard::Base.new
    end

    it 'should not save without a name' do
      @vc = Vocabularies::VCard::Base.new
      @vc.should_not be_valid
      lambda { @vc.save! }.should raise_error

      # @vc.errors[:full_name].should_not be_nil
    end

    it 'should properly save when provided portion of a name' do
      @jtk = Vocabularies::VCard::Name.new(:first_name => "James", 
                                            :middle_name => "Tiberius", 
                                            :last_name => "Kirk")

      @vc.name = @jtk
      lambda { @vc.save! }.should change(Vocabularies::VCard::Base, :count).by(1)
    end
  end
  
  describe 'Properties' do
    before(:each) do
      @vc = Vocabularies::VCard::Base.new
    end

    it 'should properly save properties and retrieve by last name' do
      @last_name = "Mudd"
      @org_name = "Future Enterprises"
      @nickname = "Harry"
      @title = "Smuggler"
      @full_name = "Harcourt Fenton #{@last_name}, III"

      @hfm = Vocabularies::VCard::Name.new(:first_name => "Harcourt", 
                                            :middle_name => "Fenton", 
                                            :last_name => @last_name,
                                            :suffix => "III")

      @org = Vocabularies::VCard::Organization.new(:name => @org_name, :department => "Sales")
      @email = Vocabularies::VCard::Email.new(:type => "Work", :value => "my_name@example.com")
      @phone1 = Vocabularies::VCard::Telephone.new(:type => "Work", :value => "202-555-1212")
      @phone2 = Vocabularies::VCard::Telephone.new(:type => "Home", :value => "202-555-3434")
      @addr = Vocabularies::VCard::Address.new(:type => "Home",
                                                :address_1 => "12 Rigel St",
                                                :address_2 => "Suite 101",
                                                :city => "Antares",
                                                :state => "AK",
                                                :zipcode => "99502",
                                                :country => "USA")

      @vc.name = @hfm
      @vc.nickname = @nickname
      @vc.title = @title
      @vc.organization = @org
      @vc.emails << @email
      @vc.telephones << @phone1 << @phone2
      @vc.addresses << @addr

      @vc.save!

      @res = Vocabularies::VCard::Base.find_by_last_name(:key => @last_name)
      @res.formatted_name.should == @full_name
      @res.nickname.should == @nickname
      @res.title.should == @title
      @res.organization.name.should == @org_name
      @res.telephones.size.should == 2
      @res.telephones.first.should be_a(Vocabularies::VCard::Telephone)
      # @res.telephones.first.value.should == @phone1.value
      # @res.addresses.first.type.should == "Home"
      @res.addresses.size.should == 1
      # @res.addresses.first.city.should == "Antares"
    end
  end

end