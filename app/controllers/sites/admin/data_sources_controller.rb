class Sites::Admin::DataSourcesController < Sites::AuthenticatedController
  layout 'sites_admin'
  before_filter :set_context

  def index
    @data_sources = LinkedData::DataSource.all
  end
  
  def show
    @data_source = LinkedData::DataSource.get(params[:id])
  end

  def new
    @data_source = LinkedData::DataSource.new
  end

  def create
    @data_source = LinkedData::DataSource.new(params[:data_source])
    @data_source.authority = @authority
    
    # raise @data_source.to_yaml

    if @data_source.save
      flash[:success] = 'Successfully created Data Source.'
      redirect_to(admin_data_source_path(@authority, @data_source))
    else
      flash[:error] = "Unable to create Data Source."
      render :new
    end
  end
  
  def edit
    @data_source = LinkedData::DataSource.get(params[:id])
  end

  def update
    @data_source = LinkedData::DataSource.get(params[:id])
    @data_source.attributes = params[:data_source]

    respond_to do |format|
      if @data_source.save
        flash[:success] = 'Successfully updated Data Source.'
        format.html { redirect_to admin_data_source_path(@authority, @data_source) }
        format.xml  { head :ok }
      else
        flash[:error] = "Error updating Data Source."
        format.html { render :edit }
        format.xml  { render :xml => @data_source.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def destroy
    
    #TODO: Blow away dependent DataSet records
    
    @data_source = LinkedData::DataSource.get(params[:id])
    unless @data_source.nil?
      @data_source.destroy
      redirect_to(admin_data_sources_url)
    else
      flash[:error] = "The Data Source could not be found, refresh the Data Source list and try again."
      redirect_to(admin_sources_url)
    end
  end
  
private
  def set_context
    @authority = authority
  end

end