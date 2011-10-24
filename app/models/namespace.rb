class Namespace

  attr_reader :base_uri, :authority, :subdomain

  def initialize(openmedia_url)
    base = openmedia_url.to_s.split("http://").last
    parts = base.split('.')
    
    # if present, shuffle the subdomain to end
    parts.length > 2 ? @subdomain = parts.delete_at(0) : @subdomain = nil
    
    @base_uri = "http://#{parts.join('.')}"
    @authority = parts.join('_')
    
    unless @subdomain.blank?
      @base_uri = @base_uri + "/#{@subdomain}"
      @authority = @authority + "_#{@subdomain}"
    end
    
    Hash[:base_uri => @base_uri, :authority => @authority, :subdomain => @subdomain]
  end

end
