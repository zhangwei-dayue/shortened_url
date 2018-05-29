class UpdateShortenedUrlUtmColumns < ActiveRecord::Migration[5.1]
  def change
    ShortenedUrl.all.each do |url|
      query_hash = Rack::Utils.parse_query URI(url.original_url).query
      url.update_columns(utm_source: query_hash["utm_source"], utm_medium: query_hash["utm_medium"], utm_term: query_hash["utm_term"], utm_content: query_hash["utm_content"], utm_campaign: query_hash["utm_campaign"])
    end
  end
end
