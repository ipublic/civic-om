class Sites::Admin::DashboardsController < Sites::AuthenticatedController

  def index
    @dashboards = Dashboard::Base.by_authority_id(:key => authority.id)
  end

  def show
    @dashboard = Dashboard::Base.get(params[:id])
  end

  def new
    @dashboard = Dashboard::Base.new
    @dashboard_group = Dashboard::Group.new
  end

  def new_group
    render :partial=>'form_dashboard_group', :locals=> { :group=>Dashboard::Group.new }
  end

  def new_measure
    render :partial=>'form_measure', :locals=> { :measure=>Dashboard::Measure.new }
  end


  def create
    @dashboard = Dashboard::Base.new(params[:dashboard])
    @dashboard.authority = authority

    if @dashboard.save
      flash[:success] = 'Successfully created Dashboard.'
      redirect_to(admin_dashboard_path(authority, @dashboard))
    else
      flash[:error] = 'Unable to create Dashboard.'
      render :action => "new"
    end
  end

  def edit
    @dashboard = Dashboard::Base.get(params[:id])
    @dashboard_groups = @dashboard.groups
  end

  def update
    @dashboard = Dashboard::Base.get(params[:id])
    @dashboard.attributes = params[:dashboard]
    @dashboard.groups = nil unless params[:dashboard][:groups]
    respond_to do |format|
      if @dashboard.save
        flash[:success] = 'Successfully updated Dashboard.'
        format.html { redirect_to(admin_dashboard_path(authority, @dashboard)) }
        format.xml  { head :ok }
      else
        flash[:error] = "Error updating Dashboard."
        format.html { render :action => "edit" }
        format.xml  { render :xml => @dashboard.errors, :status => :unprocessable_entity }
      end
    end
  end


  # DELETE /dashboards/:id
  def destroy
    @dashboard = Dashboard::Base.get(params[:id])
    unless @dashboard.nil?
      @dashboard.destroy
      redirect_to(admin_dashboards_url)
    else
      flash[:error] = "The Dashboard could not be found, refresh the Dashboard list and try again."
      redirect_to(admin_dashboards_url)
    end
  end

end
