# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Emanuel', :city => cities.first)

# Create record for Admin
admin = Vocabularies::VCard::Name.new(:first_name => "Site", :last_name => "Administrator")
vcard = Vocabularies::VCard::Base.new(:name => admin)
vcard.save!

require File.join(File.dirname(__FILE__),'seeds', 'vocabularies', 'vcard')
require File.join(File.dirname(__FILE__),'seeds', 'vocabularies', 'street_address')

require File.join(File.dirname(__FILE__),'seeds', 'topics', 'street_addresses')

