class AddQrcodeuidToShortenedUrl < ActiveRecord::Migration[5.1]
  def change
    add_column :shortened_urls, :qr_code_uid, :string
  end
end
