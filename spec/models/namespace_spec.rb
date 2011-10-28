require 'spec_helper'

describe Namespace do
  before(:all) do
    @url_with_ssl = "https://om.civicopenmedia.us"
    @url_with_subdomain = "http://om.civicopenmedia.us"
    @url_without_subdomain = "http://civicopenmedia.us"
    @url_with_path = "http://www.w3c.org/2001/XMLSchema"
  end
  
  it 'should provide proper scheme when supplied with SSL' do
    @ns = Namespace.new(@url_with_ssl)
    
    @ns.scheme.should == "https"
    @ns.display_uri.should == "https://om.civicopenmedia.us"
    @ns.base_uri.should == "https://civicopenmedia.us/om"
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
  
  it 'should provide proper namespace properties for URL with path' do
    @ns = Namespace.new(@url_with_path)

    @ns.scheme.should == "http"
    @ns.base_uri.should == "http://www.w3c.org/2001/XMLSchema"
    @ns.authority.should == "www_w3c_org"
    @ns.subdomain.should == nil   # www is ignored as a subdomain
    @ns.path.should == "/2001/XMLSchema"
  end
  

end
