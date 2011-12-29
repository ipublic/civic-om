class Sites::BaseController < ApplicationController
  layout 'sites_public'
  
  before_filter :load_site
  helper_method :current_site, :authority   # methods are visible in views
  SITE_NOT_DEFINED_ERROR_MSG = "Site not found."
  
  def load_site
    return if request.subdomains.count == 0 || Subdomain::BLACK_LIST.include?(request.subdomains.first)
    
    ## TODO - Verify this will update if we move between subdomains 
    current_site
    no_site_defined if @current_site.nil?
    authority
  end    

  def current_site
    @current_site ||= Site.by_subdomain(:key => request.subdomains.first).first if request.subdomains.count > 0
  end
  
  def authority
    @authority ||= @current_site.authority if @current_site
  end
  
  def no_site_defined
    flash[:error] = SITE_NOT_DEFINED_ERROR_MSG
    # session[:after_site_created] = params

    redirect_to url_for(:host => request.domain)
  end  
  
end
