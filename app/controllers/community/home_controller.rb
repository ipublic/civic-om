class Community::HomeController < ApplicationController
  
  def index
    @sites = Site.all
  end

end
