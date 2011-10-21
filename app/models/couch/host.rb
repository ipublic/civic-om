module Couch
  class Host
    include CouchRest::Model::Embeddable
  
    property :protocol, String, :default => 'http'
    property :host, String, :default => 'localhost'
    property :port, String, :default => '5984'
    property :username, String
    property :password, String
  
    def path
      "#{self.protocol}://#{host}:#{self.port}"
    end
  
    def authorized_host
      (self.username.blank? && self.password.blank?) ? path : "#{CGI.escape(self.username)}:#{CGI.escape(self.password)}@#{path}"
    end
  end
end