class Sites::Admin::ContactsController < Sites::AuthenticatedController
  respond_to :html, :json, :xml
  
  def index
    # @contacts = Vocabularies::VCard::Base.by_authority_id.page(authority.id)
    @contacts = Vocabularies::VCard::Base.by_authority_id(:key => authority.id)
  end
  
  def show
    @contact = Vocabularies::VCard::Base.get(params[:id])
  end
  
  def new
    @contact = Vocabularies::VCard::Base.new
  end
  
  def create
    @contact = Vocabularies::VCard::Base.new(params[:contact])

    if @contact.save
      flash[:success] = 'Successfully created Contact.'
      redirect_to(admin_contact_path(@contact))
    else
      flash[:error] = 'Unable to create Contact.'
      render :action => "new"
    end
  end

  def edit
    @contact = Vocabularies::VCard::Base.get(params[:id])
  end

  def update
    @contact = Vocabularies::VCard::Base.get(params[:id])
    @contact.attributes = params[:contact]

    respond_to do |format|
      if @contact.save
        flash[:success] = 'Successfully updated Contact.'
        format.html { redirect_to admin_contact_path(authority, contact) }
        format.xml  { head :ok }
      else
        flash[:error] = "Error updating Contact."
        format.html { render :action => "edit" }
        format.xml  { render :xml => @contact.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @contact = Vocabularies::VCard::Base.get(params[:id])
    unless @contact.nil?
      @contact.destroy
      redirect_to(admin_contacts_url)
    else
      flash[:error] = "The Contact could not be found, refresh the Contact list and try again."
      redirect_to(admin_contacts_url)
    end
  end

  
  def show_contact
    @contact = Vocabularies::VCard::Base.get(params[:id])
    respond_with @contact
  end

  
end
