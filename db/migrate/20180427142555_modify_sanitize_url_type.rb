class ModifySanitizeUrlType < ActiveRecord::Migration[5.1]
  def change
    change_column :shortened_urls, :sanitize_url, :text
  end
end
