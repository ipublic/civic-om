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
      return if database.nil?
      %W[#{self.prefix} #{database} #{self.suffix}].select {|v| !v.blank?}.join('_')
    end

    def create
      
    end

  end
end