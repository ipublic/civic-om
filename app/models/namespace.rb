class Namespace

  attr_reader :protocol, :base_uri, :authority, :subdomain

  def initialize(openmedia_url)
    pval = openmedia_url.to_s.split("://")
    pval.length < 2 ? @protocol = "http" : @protocol = pval.first
    
    base = openmedia_url.to_s.split("#{@protocol}://").last
    parts = base.split('.')
    
    # if present, shuffle the subdomain to end
    parts.length > 2 ? @subdomain = parts.delete_at(0) : @subdomain = nil
    
    @base_uri = "#{@protocol}://#{parts.join('.')}"
    @authority = parts.join('_')
    
    unless @subdomain.blank?
      @base_uri = @base_uri + "/#{@subdomain}"
      @authority = @authority + "_#{@subdomain}"
    end
    
    Hash[:prorocol => @protocool, :base_uri => @base_uri, :authority => @authority, :subdomain => @subdomain]
  end

end
