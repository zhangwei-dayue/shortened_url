class RenameShortenedUrlsIdToShortenedUrlId < ActiveRecord::Migration[5.1]
  def change
    rename_column :request_user_agents, :shortened_urls_id, :shortened_url_id
  end
end
