module Couch
  class Database
    include CouchRest::Model::Embeddable

    property :host, Couch::Host
    property :database, String
    property :prefix, String
    property :suffix, String
  
  
    def full_name
      return if name.nil?
      %W[#{self.host.authorized_host} #{name}].join('/') unless host.nil?
    end
  
    def name
      return if self.database.nil?
      %W[#{self.prefix} #{database} #{self.suffix}].select {|v| !v.blank?}.join('_')
    end

    def create
      return if self.host.nil? || self.database.nil?
      server = CouchRest.new self.host.authorized_host
      server.create_db name
    end

  end
end