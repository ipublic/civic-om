class Sites::Admin::TopicsController < Sites::AuthenticatedController
  layout 'sites_topics_admin'


  def index
    @topics = Topic.by_authority_id(:key => authority.id)
    render :layout => 'sites_admin'
  end

  def show
    @topic = Topic.get(params[:id])
  end

  def new
    @topic = Topic.new
    # @topic.authority = authority
    @contacts = Vocabularies::VCard::Base.by_authority_id_and_formatted_name.docs
    render :layout => 'sites_admin'
  end

  def create
    @topic = Topic.new(params[:topic])
    @topic.authority = authority
    
    # raise @topic.to_yaml

    if @topic.save
      flash[:success] = 'Successfully created Topic.'
      redirect_to(admin_topic_path(authority, @topic))
    else
      flash[:error] = "Unable to create Topic."
      render :new, :layout => 'sites_admin'
    end
  end
  
  def edit
    @topic = Topic.get(params[:id])
  end

  def update
    @topic = Topic.get(params[:id])
    @topic.attributes = params[:topic]

    respond_to do |format|
      if @topic.save
        flash[:success] = 'Successfully updated Topic.'
        format.html { redirect_to admin_topic_path(authority, @topic) }
        format.xml  { head :ok }
      else
        flash[:error] = "Error updating Topic."
        format.html { render :edit }
        format.xml  { render :xml => @topic.errors, :status => :unprocessable_entity }
      end
    end
  end
  

  def show_properties
    @topic = Topic.get(params[:id])
  end

  def edit_properties
    @topic = Topic.get(params[:id])
  end
  
  def update_properties
  end

  def destroy
    @topic = Topic.get(params[:id])
    unless @topic.nil?
      @topic.destroy
      redirect_to(admin_topics_url)
    else
      flash[:error] = "The Topic could not be found, refresh the Topic list and try again."
      redirect_to(admin_topics_url)
    end
  end

end
