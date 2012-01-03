class Sites::BaseController < ApplicationController
  layout 'sites_public'
  
  before_filter :load_site
  helper_method :current_site, :authority   # methods are visible in views
  SITE_NOT_DEFINED_ERROR_MSG = "Site not found."
  
  def load_site
    authority
    current_site
    no_site_defined if @current_site.nil?
  end    

  def authority
    @authority ||= Authority.get(params[:authority_id])
  end
  
  def current_site
    @current_site ||= @authority.sites.first unless @authority.nil?
  end
  
  def no_site_defined
    flash[:error] = SITE_NOT_DEFINED_ERROR_MSG
    # session[:after_site_created] = params

    redirect_to community_home_index_url
    # redirect_to url_for(:host => request.domain)
  end  
  
end
