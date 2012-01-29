class Sites::Admin::DataSourcesController < Sites::AuthenticatedController
  layout 'sites_data_sources_admin'
  before_filter :set_context

  def index
    @data_sets = LinkedData::DataSet.by_data_source_id(:key => @data_source)
    # render :layout => 'sites_admin'
  end
  
  def show
    @data_set = LinkedData::DataSet.get(params[:id])
  end

  def new
    @data_set = LinkedData::DataSet.new
  end

  def create
    @data_set = LinkedData::DataSource.new(params[:data_set])
    
    # raise @data_set.to_yaml

    if @data_set.save
      flash[:success] = 'Successfully created Data Set.'
      redirect_to(admin_data_set_path(@authority, @data_set))
    else
      flash[:error] = "Unable to create Data Set."
      render :new
    end
  end
  
  def edit
    @data_set = LinkedData::DataSet.get(params[:id])
  end

  def update
    @data_set = LinkedData::DataSet.get(params[:id])
    @data_set.attributes = params[:data_set]

    respond_to do |format|
      if @data_set.save
        flash[:success] = 'Successfully updated Data Set.'
        format.html { redirect_to admin_data_set_path(@authority, @data_set) }
        format.xml  { head :ok }
      else
        flash[:error] = "Error updating Data Source."
        format.html { render :edit }
        format.xml  { render :xml => @data_set.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def upload
    uploaded_io = params[:data_set][:file]
    render :text => uploaded_io.to_json

    # @ds = LinkedData::DataSource.new(:authority => @data_source.authority, :term => @data_source.term)
    # @ds_id = @data_source.id
    # 
    # # STAGING_DATABASE.recreate! rescue nil
    # @csv_filename = File.join(fixture_path, 'crime_incidents_current.csv')
    # @parser = Parser::CsvParser.new(@csv_filename, {:header_row => true})
    # @ds.properties = @parser.columns

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @sf}
      format.json { render :json => @sf}
    end

  end
  
  def destroy
  end

private
  def set_context
    @authority = authority
    @data_source = (params[:data_source])
  end
end