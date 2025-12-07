class CreateApprovedWorks < ActiveRecord::Migration[8.0]
  def change
    create_table :approved_works do |t|
      t.references :submission, null: false, foreign_key: true
      t.references :project, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.decimal :hours, precision: 10, scale: 2
      t.decimal :inbound_rate, precision: 10, scale: 2, default: 0.0, null: false
      t.decimal :outbound_rate, precision: 10, scale: 2, default: 0.0, null: false
      t.date :period_start
      t.date :period_end

      t.timestamps
    end
  end
end
