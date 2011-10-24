require 'spec_helper'

describe Namespace do
  before(:all) do
    @url_with_ssl = "https://om.civicopenmedia.us"
    @url_without_protocol = "om.civicopenmedia.us"
    @url_with_subdomain = "http://om.civicopenmedia.us"
    @url_without_subdomain = "http://civicopenmedia.us"
  end
  
  it 'should provide proper protocol when supplied with SSL' do
    @ns = Namespace.new(@url_with_ssl)
    
    @ns.protocol.should == "https"
    @ns.base_uri.should == "https://civicopenmedia.us/om"
    @ns.authority.should == "civicopenmedia_us_om"
    @ns.subdomain.should == "om"
  end

  it 'should provide proper protocol when in protocol is supplid' do
    @ns = Namespace.new(@url_without_protocol)

    @ns.protocol.should == "http"
    @ns.base_uri.should == "http://civicopenmedia.us/om"
    @ns.authority.should == "civicopenmedia_us_om"
    @ns.subdomain.should == "om"
  end

  it 'should provide proper namespace properties for URL WITH a subdomain' do
    @ns = Namespace.new(@url_with_subdomain)

    @ns.protocol.should == "http"
    @ns.base_uri.should == "http://civicopenmedia.us/om"
    @ns.authority.should == "civicopenmedia_us_om"
    @ns.subdomain.should == "om"
  end

  it 'should provide proper namespace properties for URL WITHOUT a subdomain' do
    @ns = Namespace.new(@url_without_subdomain)

    @ns.protocol.should == "http"
    @ns.base_uri.should == "http://civicopenmedia.us"
    @ns.authority.should == "civicopenmedia_us"
    @ns.subdomain.should == nil
  end

end
