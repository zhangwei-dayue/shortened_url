class ModifyRequestUserAgentColumns < ActiveRecord::Migration[5.1]
  def change
    rename_column :request_user_agents, :platform, :platform_name
    rename_column :request_user_agents, :browser, :browser_name
    rename_column :request_user_agents, :version, :platform_version
    add_column :request_user_agents, :browser_version, :string
  end
end
