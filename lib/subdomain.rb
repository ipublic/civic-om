class Subdomain
  
  BLACK_LIST = ['www','mail','blog','wiki','ftp','dev','gis', '', nil]
  
  def self.matches?(request)
    BLACK_LIST.include?(request.subdomain) ? false : true
  end
end