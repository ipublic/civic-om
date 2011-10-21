require 'spec_helper'

describe "Couch::Host" do
  it "should provide formatted urls with appropriate default values" do
    @host = Couch::Host.new(:username => "admin", :password => "secret", :protocol => "https", :host => "om.civicopenmedia.us")
    @host.path.should == "https://om.civicopenmedia.us:5984"
    @host.authorized_host.should == "admin:secret@https://om.civicopenmedia.us:5984"
  end
  
  it "should" do
  end
end