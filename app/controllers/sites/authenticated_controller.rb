class Sites::AuthenticatedController < Sites::BaseController
  layout 'sites_admin'
  
  before_filter :authenticate_user!
#  before_filter :check_for_subdomain
  

private
  def check_for_subdomain
    if current_site.nil?
      redirect_to root_path
    elsif current_user && (current_user.site.subdomain != request.subdomains.first)
      redirect_to "#{current_user.site.url}/admin"
    end
  end
  
end
