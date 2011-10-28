require "addressable/uri"
class Namespace

  attr_reader :scheme, :base_uri, :path, :authority, :subdomain, :display_uri

  def initialize(openmedia_url)
    uri = Addressable::URI.parse(openmedia_url.to_s)
    @display_uri = uri.to_s
    @path = uri.path
    
    uri.scheme.nil? ? @scheme = "http" : @scheme = uri.scheme
    host_parts = uri.host.split('.')

    # if present, shuffle the subdomain to end
    (host_parts.length > 2 && host_parts.first.to_i == 0 && host_parts.first.to_s.downcase != 'www') ? @subdomain = host_parts.delete_at(0) : @subdomain = nil
    
    @base_uri = "#{@scheme}://#{host_parts.join('.')}"
    @authority = host_parts.join('_')
    
    unless @subdomain.blank?
      @base_uri = @base_uri + "/#{@subdomain}"
      @authority = @authority + "_#{@subdomain}"
    end
    
    @base_uri = @base_uri + @path unless @path.nil?
    
    Hash[:authority => @authority, :scheme => @scheme, :base_uri => @base_uri, :path => @path, :subdomain => @subdomain, :uri_string => @display_uri]
  end

end
