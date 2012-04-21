class Sites::Admin::DataSetsController < Sites::AuthenticatedController
  layout 'sites_data_sources_admin'
  before_filter :set_context

  def index
    @data_sets = DataSet.by_data_source_id(:key => @data_source)
    # render :layout => 'sites_admin'
  end
  
  def show
    @data_source = authority.data_sources.get(params[:data_source_id])
    @data_set = DataSet.get(params[:id])
  end

  def new
    # raise params.to_yaml
    @data_source = authority.data_sources.get(params[:data_source_id])
    @data_set = DataSet.new
  end

  def edit
    @data_set = DataSet.get(params[:id])
  end

  def update
    @data_set = DataSet.get(params[:id])
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
  
  # def create
  #   @data_set = LinkedData::DataSource.new(params[:data_set])
  #   
  #   # raise @data_set.to_yaml
  # 
  #   if @data_set.save
  #     flash[:success] = 'Successfully created Data Set.'
  #     redirect_to(admin_data_set_path(@authority, @data_set))
  #   else
  #     flash[:error] = "Unable to create Data Set."
  #     render :new
  #   end
  # end
  
  def upload
    # raise params.to_yaml
    # render :text => @uploaded_io.to_json
    @data_source = authority.data_sources.get(params[:data_source_id])
    
    @temp = File.open(params[:data_set][:file].tempfile)
    @filename = params[:data_set][:file].original_filename
    @safe_filename = sanitize_filename(@filename)
    
    @data_set = DataSet.new(:label => @safe_filename)
    @data_set.database = @data_source.database
    @data_set.save
    @data_set.create_attachment(:name => @safe_filename, :file => @temp)

    respond_to do |format|
      if @data_set.save
        
        @data_source.data_set_ids << @data_set.id
        @data_source.save
        
        flash[:success] = "Successfully uploaded file: #{@safe_filename} to db: #{@data_set.database} in doc: #{@data_set.id}"
        format.html { redirect_to(admin_data_source_path(@authority, @data_source)) }
        format.xml  { head :ok }
      else
        flash[:error] = "Error uploading file: #{@filename}"
        format.html { render :edit }
        format.xml  { render :xml => @data_set.errors, :status => :unprocessable_entity }
      end
    end
  end
   
  def extract
    @data_source = authority.data_sources.get(params[:data_source_id])
    @data_set = @data_source.database.get(params[:id])
    
    @file_io = @data_source.database.fetch_attachment(params[:id], @data_set["label"])
    render :text => @file_io.to_json
  end
  
  def show_raw_records
    @data_source = authority.data_sources.get(params[:data_source_id])

    count = @data_source.raw_record_count
    records = @data_source.raw_records(:limit => params[:iDisplayLength], :skip => params[:iDisplayStart])

    render :json=>{
      :sEcho=>params[:sEcho],
      :aaData=>records.collect{|rr| @data_source.source_properties.collect{|p| rr[p.identifier]}},
      :iTotalRecords=>count,
      :iTotalDisplayRecords=>count
    }
  end
  
  def destroy
  end

  def sanitize_filename(file_name)
    file_name.strip.tap do |name|
      # NOTE: File.basename doesn't work right with Windows paths on Unix
      # get only the filename, not the whole path
      name.sub! /\A.*(\\|\/)/, ''
      # Finally, replace all non alphanumeric, underscore
      # or periods with underscore
      name.gsub! /[^\w\.\-]/, '_'
    end
  end

  def content_type1(filename)
    extension = File.extname(filename)[1..-1]

    # return application/octet-stream if unknown content_type
    mime_type = Mime::Type.lookup_by_extension(extension) || mime_type = "application/octet-stream"
  end

private
  def set_context
    @authority = authority
    @data_source = LinkedData::DataSource.get(params[:data_source_id])
  end


  
end