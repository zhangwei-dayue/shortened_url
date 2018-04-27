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
    if @url.new_url?
      if @url.save
        qr_code_img = RQRCode::QRCode.new(@url.original_url, size: 26, level: :h ).to_img.resize(300, 300)
        @url.update_attributes(qr_code: qr_code_img.to_string)
        redirect_to shortened_path(@url.short_url)
      else
        render :index
      end
    else
      flash[:alert] = '该链接已经生成过短网址'
      redirect_to shortened_path(@url.find_duplicate.short_url)
    end
  end

  def shortened
    @url = ShortenedUrl.find_by_short_url(params[:short_url])
    host = request.host_with_port
    @original_url = @url.original_url
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
