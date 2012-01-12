class Sites::Admin::SettingsController < Sites::AuthenticatedController
  layout 'sites_settings_admin'
  
  def index
    redirect_to admin_site_path(authority)
  end

end
