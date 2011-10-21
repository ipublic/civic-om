require 'spec_helper'

describe "Couch::Database" do

  before(:all) do
    @host = Couch::Host.new(:username => "admin", :password => "secret", :protocol => "https", :host => "om.civicopenmedia.us")
    @pfx = "om"
    @sfx = "dev"
    @db_name = "commons"
    @db = Couch::Database.new(:host => @host, :database => @db_name, :prefix => @pfx, :suffix => @sfx)
  end

  it 'should properly set and get properties' do
    @db.host.should == @host
    @db.database.should == @db_name
    @db.prefix.should == @pfx
    @db.suffix.should == @sfx
  end

  describe 'Class instance methods' do
    it ".name" do
      @db.name.should == %W[#{@pfx} #{@db_name} #{@sfx}].join('_')
    end

    it ".full_name" do
      @db.full_name.should == @host.authorized_host + '/' + %W[#{@pfx} #{@db_name} #{@sfx}].join('_')
    end

    it "should not include delimeter on end of string if no suffix is supplied" do
      @no_sfx_db = Couch::Database.new(:host => @host, :database => @db_name, :prefix => @pfx)
      @no_sfx_db.name.should == @pfx + '_' + @db_name
    end

    it "should return nil if properties aren't set" do
      @empty_db = Couch::Database.new
      @empty_db.name.should == nil
      @empty_db.full_name.should == nil
    end
  end
  
end