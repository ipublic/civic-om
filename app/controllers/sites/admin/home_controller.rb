class Sites::Admin::HomeController < Sites::AuthenticatedController

  def index
    @site = current_site
  end

end
