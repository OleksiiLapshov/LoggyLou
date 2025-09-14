class AddProjectIdToWorklogs < ActiveRecord::Migration[8.0]
  def change
    add_reference :worklogs, :project, null: false, foreign_key: true
  end
end
