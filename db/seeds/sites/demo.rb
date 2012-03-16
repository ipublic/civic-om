## Initialize demo site
email = 'site_admin@example.com'
pw = 'password'
domain = 'demo.gov'
label = "Demo Site"
tag_line = "Your source for government open data"

# Initialize Authority
authority = Authority.create!(:site_domain => domain, :label => label)

# Create a VCard record for Admin
contact = Vocabularies::VCard::Base.new(:authority => authority,
                                        :name => Vocabularies::VCard::Name.new(:first_name => "John", 
                                                                                :last_name => "Doe"))

contact.emails << Vocabularies::VCard::Email.new(:type => 'Work', :value => email)
contact.telephones << Vocabularies::VCard::Telephone.new(:type => 'Work', :value => '202-555-1212')
contact.addresses << Vocabularies::VCard::Address.new(:type => 'Work',
                                                      :address_1 => "404 4th Street NW",
                                                      :city => "Washington", 
                                                      :state => "DC",
                                                      :zipcode => "20010",
                                                      :country => "USA")
contact.save!

# Use devise gem to create User record 
user = User.create!(:email => email, 
                    :password => pw, 
                    :password_confirmation => pw,
                    :authority => authority,
                    :confirmed_at => Time.now.utc)


# Create Site record
site = Site.new(:authority => authority, 
                :label => label, 
                :tag_line => tag_line,
                :administrator_contact => contact).save

# Associate the Site with User
# user = User.get(email)
# user.site = site
# user.save!
