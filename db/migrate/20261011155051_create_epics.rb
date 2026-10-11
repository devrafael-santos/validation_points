class CreateEpics < ActiveRecord::Migration[8.1]
  def change
    create_table :epics do |t|
      t.string :name, null: false
      t.string :jira_key, null: false
      t.integer :project_type, null: false, default: 0
      t.text :description

      t.timestamps
    end

    add_index :epics, :jira_key, unique: true
  end
end
