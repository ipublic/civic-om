require "addressable/uri"
class Namespace

  attr_reader :scheme, :base_uri, :authority, :subdomain

  def initialize(openmedia_url)
    uri = Addressable::URI.parse(openmedia_url.to_s)
    
    uri.scheme.nil? ? @scheme = "http" : @scheme = uri.scheme

    # addressable leaves host value as nil when input scheme/protocol is missing
    uri.host.nil? ? parts = uri.path.split('.') : parts = uri.host.split('.')

    # if present, shuffle the subdomain to end
    parts.length > 2 ? @subdomain = parts.delete_at(0) : @subdomain = nil
    
    @base_uri = "#{@scheme}://#{parts.join('.')}"
    @authority = parts.join('_')
    
    unless @subdomain.blank?
      @base_uri = @base_uri + "/#{@subdomain}"
      @authority = @authority + "_#{@subdomain}"
    end
    
    Hash[:scheme => @scheme, :base_uri => @base_uri, :authority => @authority, :subdomain => @subdomain]
  end

end
