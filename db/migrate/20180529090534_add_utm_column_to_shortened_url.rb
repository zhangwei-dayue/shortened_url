class AddUtmColumnToShortenedUrl < ActiveRecord::Migration[5.1]
  def change
    add_column :shortened_urls, :utm_source, :string
    add_column :shortened_urls, :utm_medium, :string
    add_column :shortened_urls, :utm_term, :string
    add_column :shortened_urls, :utm_content, :string
    add_column :shortened_urls, :utm_campaign, :string
  end
end
