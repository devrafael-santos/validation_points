class CreateTasks < ActiveRecord::Migration[8.1]
  def change
    create_table :tasks do |t|
      t.references :epic, null: false, foreign_key: true
      t.string :title, null: false
      t.string :jira_key, null: false
      t.string :jira_url
      t.string :pull_request_url
      t.text :description
      t.integer :stage, null: false, default: 0
      t.integer :priority, null: false, default: 1
      t.integer :story_points

      t.timestamps
    end

    add_index :tasks, :jira_key, unique: true
    add_index :tasks, :stage
    add_index :tasks, :priority
  end
end
