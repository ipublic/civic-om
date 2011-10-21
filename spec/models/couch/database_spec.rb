require 'spec_helper'

describe "Couch::Database" do

  before(:all) do
    @host = Couch::Host.new(:username => "admin", :password => "secret", :protocol => "https", :host => "om.civicopenmedia.us")
    @local_host = Couch::Host.new(:protocol => "http", :host => "localhost")
    
    @pfx = "om"
    @sfx = "dev"
    @db_root_name = "commons"
    @db_full_name = %W[#{@pfx} #{@db_root_name} #{@sfx}].join('_')
    @db = Couch::Database.new(:host => @host, :database => @db_root_name, :prefix => @pfx, :suffix => @sfx)
  end

  describe 'initailization' do
    it 'should properly set and get properties' do
      @db.host.should == @host
      @db.database.should == @db_root_name
      @db.prefix.should == @pfx
      @db.suffix.should == @sfx
    end
  end

  describe 'Class instance methods' do
    describe '.name' do
      it "should provide a database name from supplied component properties" do
        @db.name.should == @db_full_name
      end

      it "should not include delimeter on end of string if no suffix is supplied" do
        @no_sfx_db = Couch::Database.new(:host => @host, :database => @db_root_name, :prefix => @pfx)
        @no_sfx_db.name.should == @pfx + '_' + @db_root_name
      end

      it "should return nil if properties aren't set" do
        @empty_db = Couch::Database.new
        @empty_db.name.should == nil
      end
    end
    
    describe '.full_name' do
      it "should provide a server and database name from supplied component properties" do
        @db.full_name.should == @host.authorized_host + '/' + @db_full_name
      end

      it "should return nil if properties aren't set" do
        @empty_db = Couch::Database.new
        @empty_db.full_name.should == nil
      end
    end
      
    describe '.create' do
      it 'should create a CouchDB Database' do
        @new_db = Couch::Database.new(:host => @local_host, :database => @db_root_name, :prefix => @pfx, :suffix => @sfx)
        @res = @new_db.create
        @res.should be_a(CouchRest::Database)
        @res.name.should == @db_full_name
      end
    end
  end
end