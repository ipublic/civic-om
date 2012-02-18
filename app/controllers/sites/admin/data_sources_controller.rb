require_dependency 'csv'

class Sites::Admin::DataSourcesController < Sites::AuthenticatedController
  layout 'sites_admin'
  before_filter :set_context

  def index
    @data_sources = authority.data_sources.by_label.all
  end
  
  def new
    @data_source = authority.data_sources.new
  end

  def show
    @data_source = authority.data_sources.get(params[:id])
    @data_sets = @data_source.attachments
    render :layout => 'sites_data_sources_admin'
  end

  def create
    @data_source = authority.data_sources.new(params[:data_source])

    if @data_source.save
      flash[:success] = 'Successfully created Data Source.'
      redirect_to(admin_data_source_path(@authority, @data_source))
    else
      flash[:error] = "Unable to create Data Source."
      render :new
    end
  end
  
  def edit
    @data_source = authority.data_sources.get(params[:id])
  end

  def update
    @data_source = authority.data_sources.get(params[:id])
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
  
  def file_source
    @data_source = authority.data_sources.get(params[:id])
  end
  
  def upload_file
    # raise params.to_yaml
    # render :text => @uploaded_io.to_json
    @data_source = authority.data_sources.get(params[:id])
    
    @temp = File.open(params[:file_source][:file].tempfile)
    @filename = params[:file_source][:file].original_filename
    @safe_filename = sanitize_filename(@filename)

    @data_source.create_attachment(:name => @safe_filename, :file => @temp)

    respond_to do |format|
      if @data_source.save
        logger.debug("Successfully uploaded file: #{@safe_filename} to db: #{@data_source.database} in doc: #{@data_source.id}")
        
        flash[:success] = "Successfully uploaded file: #{@safe_filename}"
        format.html { redirect_to(admin_data_source_path(@authority, @data_source)) }
        format.xml  { head :ok }
      else
        flash[:error] = "Error uploading file: #{@filename}"
        format.html { render :edit }
        format.xml  { render :xml => @data_set.errors, :status => :unprocessable_entity }
      end
    end
  end  
    
  def parse
    # raise params.to_yaml
    @data_source = authority.data_sources.get(params[:id])
    @attach_name = params[:attach_name]
    @data_set = @data_source.attachments[@attach_name]

    @mime_type = @data_set["content_type"]
    @file_io = @data_source.database.fetch_attachment(params[:id], @attach_name)
    
    case @mime_type
      when "text/csv"
        @recs = CSV.parse(@file_io)
        # @parser = Parser::CsvParser.new(@file_io, {:header_row => false})
      when "application/zip"
        @parser = Parser::ShapefileParser.new(@shapefile_name)
    end
    @recs
  end
  
  def show_raw_records
    @data_source = authority.data_sources.get(params[:id])

    count = @data_source.raw_record_count
    records = @data_source.raw_records(:limit => params[:iDisplayLength], :skip => params[:iDisplayStart])

    render :json=>{
      :sEcho=>params[:sEcho],
      :aaData=>records.collect{|rr| @data_source.source_properties.collect{|p| rr[p.identifier]}},
      :iTotalRecords=>count,
      :iTotalDisplayRecords=>count
    }
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

  def destroy
    @data_source = authority.data_sources.get(params[:id])
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