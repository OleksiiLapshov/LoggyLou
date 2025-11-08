class CreateSubmissions < ActiveRecord::Migration[8.0]
  def change
    create_table :submissions do |t|
      t.references :user, null: false, foreign_key: true
      t.date :period_start
      t.date :period_end
      t.integer :status, default: 0, null: false
      t.text :note

      t.timestamps
    end
  end
end
