class AddQueryStringToRequestUserAgent < ActiveRecord::Migration[5.1]
  def change
    add_column :request_user_agents, :query_string, :string
  end
end
