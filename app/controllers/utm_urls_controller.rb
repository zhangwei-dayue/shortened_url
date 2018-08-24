class UtmUrlsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def new
    @utm_url = UtmUrl.new
  end

  def show
    @utm_url = UtmUrl.find(params[:id])
  end

  def create
    @utm_url = UtmUrl.new(utm_params)
    @utm_url.generate_utm_url

    respond_to do |format|
      if @utm_url.new_utm_url?
        if @utm_url.save
          format.html { redirect_to utm_url_path(@utm_url) }
        else
          format.html { render :new }
        end
      else
        flash[:alert] = '之前已经生成过该 UTM 链接'
        @utm_url = @utm_url.find_duplicate
        format.html { redirect_to utm_url_path(@utm_url) }
      end
    end
  end

  private
    def utm_params
      params.require(:utm_url).permit(:original_url, :source, :source_link_type, :source_obj_id, :utm_source, :utm_medium, :utm_campaign, :utm_content)
    end
end
