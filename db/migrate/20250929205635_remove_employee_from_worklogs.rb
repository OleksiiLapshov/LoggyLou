class RemoveEmployeeFromWorklogs < ActiveRecord::Migration[8.0]
  def change
    remove_column :worklogs, :employee, :string
  end
end
