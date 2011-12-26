class User < CouchRest::Model::Base  
  use_database SITES_DATABASE
  unique_id :email

  belongs_to :site
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
  
  # before_save :ensure_authentication_token
  
  
  view_by :email
  view_by :confirmation_token
  view_by :site_id
  
  # design do
  #  view :by_email
  #  view :by_confirmation_token
  #  view :by_site_id
  # end
  
  def self.find(id, opts=nil)
   if id == :first
     if opts[:conditions] && opts[:conditions][:id]
       self.find(opts[:conditions][:id])
     elsif opts[:conditions] && opts[:conditions][:email]
       self.find_by_email(opts[:conditions][:email])
     elsif opts[:conditions] && opts[:conditions][:confirmation_token]
       self.find_by_confirmation_token(opts[:conditions][:confirmation_token])
     end
   else
     super(id)
   end
  end

  def remember_created_at
    self['remember_created_at'].to_time if self['remember_created_at']
  end


end
