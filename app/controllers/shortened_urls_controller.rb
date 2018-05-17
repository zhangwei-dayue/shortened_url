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

  def send_png_file
    @url = ShortenedUrl.find_by_original_url(url_params[:original_url])
    render json: {message: '你请求的网站还未生成短网址，请先生成短网址再进行操作', success: false}, status: :unprocessable_entity and return if @url.blank?
    prefix = "/shared/public/dragonfly/"
    file = [Rails.root.to_s.split("/release").first, prefix, Rails.env, @url.qr_code_uid].join
    data = open(file).read
    respond_to do |format|
      format.png do
        send_data data, type: 'image/png', disposition: 'inline'
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
