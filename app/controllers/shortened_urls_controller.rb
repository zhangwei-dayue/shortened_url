class ShortenedUrlsController < ApplicationController
  before_action :find_url, only: [:show, :shortened]
  skip_before_action :verify_authenticity_token

  def index
    @url = ShortenedUrl.new
  end

  def show
    redirect_to @url.original_url
  end

  def create
    @url = ShortenedUrl.new(url_params)
    @url.sanitize
    @host = request.host_with_port

    respond_to do |format|
      if @url.new_url?
        if @url.save
          short_url = 'http://' + @host + '/' + @url.short_url
          qr_code_img = RQRCode::QRCode.new(short_url, level: :h ).to_img.resize(300, 300)

          @url.update_attributes(qr_code: qr_code_img.to_string)
          format.html { redirect_to shortened_path(@url.short_url) }
          format.json { render :show, status: :ok }
        else
          format.html { render :index }
          format.json { render json: { message: @url.errors.full_messages, success: false}, status: :unprocessable_entity }
        end
      else
        flash[:alert] = '该链接已经生成过短网址'
        @url = @url.find_duplicate
        format.html { redirect_to shortened_path(@url.short_url) }
        format.json { render :show, status: :ok }
      end
    end
  end

  def shortened
    @url = ShortenedUrl.find_by_short_url(params[:short_url])
    host = request.host_with_port
    @short_url = host + '/' + @url.short_url
  end

  def fetch_original_url
    fetch_url = ShortenedUrl.find_by_short_url(params[:short_url])
    redirect_to fetch_url.sanitize_url
  end

  private
    def find_url
      @url = ShortenedUrl.find_by_short_url(params[:short_url])
    end

    def url_params
      params.require(:shortened_url).permit(:original_url)
    end
end
