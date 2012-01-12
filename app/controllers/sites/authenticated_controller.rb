class Sites::AuthenticatedController < Sites::BaseController
  layout 'sites_admin'
  
  before_filter :authenticate_user!
  
end
