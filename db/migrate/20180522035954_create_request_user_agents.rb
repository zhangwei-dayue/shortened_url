class CreateRequestUserAgents < ActiveRecord::Migration[5.1]
  def change
    create_table :request_user_agents do |t|
      t.string :platform
      t.string :browser
      t.string :version

      t.timestamps
    end
  end
end
