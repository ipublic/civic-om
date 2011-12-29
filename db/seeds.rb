# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Emanuel', :city => cities.first)

## Initialize demo site
email = 'site_admin@example.com'
pword = 'password'
subdomain = 'demo'
label = "OpenMedia Demonstration"
tag_line = "Your site for government open data"

# Create a VCard record for Admin
contact = Vocabularies::VCard::Base.new(:name => Vocabularies::VCard::Name.new(:first_name => "John", 
                                                                                :last_name => "Doe"))

contact.emails << Vocabularies::VCard::Email.new(:type => 'Work', :value => email)
contact.save!

# Use devise gem to create User record 
user = User.create!(:email => email, 
                    :password => pword, 
                    :password_confirmation => pword,
                    :confirmed_at => Time.now.utc)


# Create Site record
site = Site.new(:subdomain => subdomain, 
                :label => label, 
                :tag_line => tag_line,
                :administrator_contact => contact).save

# Associate the Site with User
user = User.get(email)
user.site = site
user.save!



# require File.join(File.dirname(__FILE__),'seeds', 'vocabularies', 'v_card')
# require File.join(File.dirname(__FILE__),'seeds', 'vocabularies', 'street_address')
# require File.join(File.dirname(__FILE__),'seeds', 'topics', 'street_addresses')

