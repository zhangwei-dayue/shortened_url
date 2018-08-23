class UtmUrlsController < ApplicationController
  def new
    @utm_url = UtmUrl.new
  end
end
