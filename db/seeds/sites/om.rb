## Initialize Authorities for OpenMedia commons and iPublic
om_domain = 'civicopenmedia.com'
om_label = "OpenMedia Site"
om_tag_line = "Your source for government open data"

ipublic_domain = 'ipublic.org'
ipublic_label = "iPublic Site"
ipublic_tag_line = "Your source for government open data"

om_authority = Authority.create!(:site_domain => om_domain, :label => om_label)
ipublic_authority = Authority.create!(:site_domain => ipublic_domain, :label => ipublic_label)

# Create a VCard record for Admin
contact = Vocabularies::VCard::Base.new(:authority => ipublic_authority,
                                        :name => Vocabularies::VCard::Name.new(:first_name => "Dan", 
                                                                                :last_name => "Thomas"))

contact.emails << Vocabularies::VCard::Email.new(:type => 'Work', :value => email)
contact.telephones << Vocabularies::VCard::Telephone.new(:type => 'Work', :value => '202-525-7570')
contact.addresses << Vocabularies::VCard::Address.new(:type => 'Work',
                                                      :city => "Washington", 
                                                      :state => "DC",
                                                      :country => "USA")
contact.save!

# Use devise gem to create User record 
email = 'dan.thomas@ipublic.org'
pw = 'password'

user = User.create!(:email => email, 
                    :password => pw, 
                    :password_confirmation => pw,
                    :authority => ipublic_authority,
                    :confirmed_at => Time.now.utc)


# Create Site record
site = Site.new(:authority => ipublic_authority, 
                :label => ipublic_label, 
                :tag_line => ipublic_tag_line,
                :administrator_contact => contact).save

# Associate the Site with User
# user = User.get(email)
# user.site = site
# user.save!
