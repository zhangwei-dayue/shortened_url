class ModifyUserAgentDataStructure < ActiveRecord::Migration[5.1]
  def change
    rename_column :request_user_agents, :platform_name, :user_agent_content
    change_column :request_user_agents, :user_agent_content, :text
    remove_column :request_user_agents, :browser_name
    remove_column :request_user_agents, :platform_version
    remove_column :request_user_agents, :browser_version

    add_column :shortened_urls, :request_count, :integer
  end
end
