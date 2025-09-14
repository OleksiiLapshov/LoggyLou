class CreateWorklogs < ActiveRecord::Migration[8.0]
  def change
    create_table :worklogs do |t|
      t.string :employee, null: false
      t.float :hours, null: false, default: 0.0
      t.text :note, null: false
      t.string :project, null: false
      t.date :log_date, null: false

      t.timestamps
    end
  end
end
