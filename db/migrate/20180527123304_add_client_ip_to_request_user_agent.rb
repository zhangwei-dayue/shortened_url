class AddClientIpToRequestUserAgent < ActiveRecord::Migration[5.1]
  def change
    add_column :request_user_agents, :client_ip, :string
  end
end
