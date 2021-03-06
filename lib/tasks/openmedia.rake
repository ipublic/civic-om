namespace :openmedia do

  desc "Seed the couchdb database with once/ and always/ fixtures."
  task :seed => :environment do 
    load File.join(Rails.root, 'db', 'seeds.rb')
  end

  desc "create the couchdb databases for the current environment"
  task :create_dbs => :environment do
    SITES_DATABASE.create!
    SCHEMA_DATABASE.create!
  end 

  desc "drop the couchdb databases for the current environment"
  task :drop_dbs => :environment do
    Site.all.each do |site|
      COUCHDB_SERVER.databases.each do |db|
        COUCHDB_SERVER.database(db).delete! if db =~ Regexp.new("^civic_om_")
        COUCHDB_SERVER.database(db).delete! if db =~ Regexp.new("^#{site.authority.term}_")
      end
    end 
    SITES_DATABASE.delete! rescue nil
    SCHEMA_DATABASE.delete! rescue nil
  end

  desc "create couchdb databases and load seeds"
  task :setup => [:environment, :create_dbs, :seed]

  desc "drop couchdb databases, then create couchdb databases and load seeds"
  task :reset => [:environment, :drop_dbs, :create_dbs, :seed]

  
end
