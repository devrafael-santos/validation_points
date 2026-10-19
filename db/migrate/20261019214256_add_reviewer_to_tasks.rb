class AddReviewerToTasks < ActiveRecord::Migration[8.1]
  def change
    add_reference :tasks, :reviewer, null: true, foreign_key: { to_table: :users }
  end
end
