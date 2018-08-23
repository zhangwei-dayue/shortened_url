class CreateUtmUrls < ActiveRecord::Migration[5.1]
  def change
    create_table :utm_urls do |t|
      t.text :original_url
      t.text :utm_url
      t.string :source
      t.string :source_link_type
      t.string :source_obj_id
      t.string :utm_source
      t.string :utm_medium
      t.string :utm_campaign
      t.string :utm_content

      t.timestamps
    end
  end
end
