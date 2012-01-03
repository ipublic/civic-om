class Sites::Admin::HomeController < Sites::AuthenticatedController
  respond_to :html, :json, :xml

  def index
    @site = current_site
  end

  def show
    @site = Site.get(params[:id])
  end
  
  def create
    @site = Site.new(params[:site])

    if @site.save
      flash[:notice] = 'Site successfully created.'
      if session[:after_site_created]
        return_to = session[:after_site_created]
        session[:after_site_created] = nil
        redirect_to(return_to)
      else
        redirect_to(admin_site_path)
      end
    else
      flash[:error] = 'Unable to create Site.'
      render :action => "new"
    end
  end

  def edit
    @site = Site.get(params[:id])
  end
  
  def update
    @site = Site.get(params[:id])
    @site.attributes = params[:site]
    
    # @site.municipality = OpenMedia::InferenceRules::GeographicName.find_by_name_and_id(params[:site][:municipality][:name],
    #                                                                                    params[:site][:municipality][:source_id].to_i)
    # @site.municipality.description = params[:site][:municipality][:description]
    # respond_with @site
    
    respond_to do |format|
      if @site.save
        flash[:notice] = 'Successfully updated site settings.'
        format.html { redirect_to(admin_home_path) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @site.errors, :status => :unprocessable_entity }
      end
    end
  end

end
