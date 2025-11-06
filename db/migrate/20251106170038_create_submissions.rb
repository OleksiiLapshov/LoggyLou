class CreateSubmissions < ActiveRecord::Migration[8.0]
  def change
    create_table :submissions do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :status, null: false, default: 0
      t.datetime :submitted_at
      t.datetime :reviewed_at
      t.integer :reviewed_by_id
      t.text :rejection_reason
      t.date :period_start
      t.date :period_end

      t.timestamps
    end

    add_foreign_key :submissions, :users, column: :reviewed_by_id
    add_index :submissions, :reviewed_by_id
    add_index :submissions, :status
  end
end
