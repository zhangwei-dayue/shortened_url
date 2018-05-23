class RenameShortenedUrlsIdToShortenedUrlId < ActiveRecord::Migration[5.1]
  def change
    add_reference :request_user_agents, :shortened_urls, index: true
    rename_column :request_user_agents, :shortened_urls_id, :shortened_url_id
  end
end
