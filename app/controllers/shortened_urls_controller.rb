class ShortenedUrlsController < ApplicationController
  before_action :find_url, only: [:show, :shortened]
  before_action :update_request_statistics, only: [:show]
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
        query_hash = Rack::Utils.parse_query URI(@url.original_url).query
        @url.utm_source = query_hash["utm_source"]
        @url.utm_medium = query_hash["utm_medium"]
        @url.utm_term = query_hash["utm_term"]
        @url.utm_content = query_hash["utm_content"]
        @url.utm_campaign = query_hash["utm_campaign"]

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

  def png_way
    @url = ShortenedUrl.new(url_params)
    @url.sanitize
    @host = request.host_with_port
    prefix = "/shared/public/dragonfly/"

    respond_to do |format|
      if @url.new_url?
        query_hash = Rack::Utils.parse_query URI(@url.original_url).query
        @url.utm_source = query_hash["utm_source"]
        @url.utm_medium = query_hash["utm_medium"]
        @url.utm_term = query_hash["utm_term"]
        @url.utm_content = query_hash["utm_content"]
        @url.utm_campaign = query_hash["utm_campaign"]

        if @url.save
          short_url = 'http://' + @host + '/' + @url.short_url
          qr_code_img = RQRCode::QRCode.new(short_url, level: :h ).to_img.resize(300, 300)

          @url.update_attributes(qr_code: qr_code_img.to_string)

          file = [Rails.root.to_s.split("/release").first, prefix, Rails.env, '/', @url.qr_code_uid].join
          data = open(file).read

          format.png do
            send_data data, type: 'image/png', disposition: 'inline'
          end
        else
          format.json { render json: { message: @url.errors.full_messages, success: false}, status: :unprocessable_entity }
        end
      else
        flash[:alert] = '该链接已经生成过短网址'
        @url = @url.find_duplicate
        file = [Rails.root.to_s.split("/release").first, prefix, Rails.env, '/', @url.qr_code_uid].join
        data = open(file).read

        format.png do
          send_data data, type: 'image/png', disposition: 'inline'
        end
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

    def update_request_statistics
      user_agent = request.user_agent

      @url.request_user_agents.create(user_agent_content: user_agent, client_ip: request.remote_ip)

      # 更新请求数量
      @url.increment!(:request_count)
    end

    def url_params
      params.require(:shortened_url).permit(:original_url)
    end
end
