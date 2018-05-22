class CreateViewStatistics < ActiveRecord::Migration[5.1]
  def change
    create_table :view_statistics do |t|
      t.integer :shortened_url_id
      t.integer :request_user_agent_id
      t.integer :count

      t.timestamps
    end
  end
end
