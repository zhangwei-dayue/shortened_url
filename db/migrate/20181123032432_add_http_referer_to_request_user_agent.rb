class AddHttpRefererToRequestUserAgent < ActiveRecord::Migration[5.1]
  def change
    add_column :request_user_agents, :http_referer, :string
  end
end
