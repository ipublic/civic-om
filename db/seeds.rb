# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Emanuel', :city => cities.first)

## Once - seed scripts that run only once per installation

# Set up base types
require File.join(File.dirname(__FILE__),'seeds', 'types', 'base_types')

# Initialize default sites
require File.join(File.dirname(__FILE__),'seeds', 'sites', 'om')
require File.join(File.dirname(__FILE__),'seeds', 'sites', 'demo')

## Always - seed scripts that run regardless of environment



## Development - seed scripts that run only in development environment

# require File.join(File.dirname(__FILE__),'seeds', 'vocabularies', 'v_card')
# require File.join(File.dirname(__FILE__),'seeds', 'vocabularies', 'street_address')
# require File.join(File.dirname(__FILE__),'seeds', 'topics', 'street_addresses')

