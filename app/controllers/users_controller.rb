class UsersController < Sites::BaseController
  layout 'sites_settings_admin'

  def show
    @user = User.find(params[:id])

  end

end