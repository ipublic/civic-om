require 'spec_helper'

describe Namespace do
  before(:all) do
    @url_with_ssl = "https://om.civicopenmedia.us"
    @url_without_scheme = "om.civicopenmedia.us"
    @url_with_subdomain = "http://om.civicopenmedia.us"
    @url_without_subdomain = "http://civicopenmedia.us"
  end
  
  it 'should provide proper scheme when supplied with SSL' do
    @ns = Namespace.new(@url_with_ssl)
    
    @ns.scheme.should == "https"
    @ns.display_uri.should == "https://om.civicopenmedia.us"
    @ns.base_uri.should == "https://civicopenmedia.us/om"
    @ns.authority.should == "civicopenmedia_us_om"
    @ns.subdomain.should == "om"
  end

  it 'should provide proper scheme when in scheme is supplid' do
    @ns = Namespace.new(@url_without_scheme)

    @ns.scheme.should == "http"
    @ns.base_uri.should == "http://civicopenmedia.us/om"
    @ns.authority.should == "civicopenmedia_us_om"
    @ns.subdomain.should == "om"
  end

  it 'should provide proper namespace properties for URL WITH a subdomain' do
    @ns = Namespace.new(@url_with_subdomain)

    @ns.scheme.should == "http"
    @ns.base_uri.should == "http://civicopenmedia.us/om"
    @ns.authority.should == "civicopenmedia_us_om"
    @ns.subdomain.should == "om"
  end

  it 'should provide proper namespace properties for URL WITHOUT a subdomain' do
    @ns = Namespace.new(@url_without_subdomain)

    @ns.scheme.should == "http"
    @ns.base_uri.should == "http://civicopenmedia.us"
    @ns.authority.should == "civicopenmedia_us"
    @ns.subdomain.should == nil
  end

end
