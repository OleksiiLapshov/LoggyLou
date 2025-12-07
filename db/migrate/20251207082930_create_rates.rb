class CreateRates < ActiveRecord::Migration[8.0]
  def change
    create_table :rates do |t|
      t.references :project, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.decimal :inbound_rate, precision: 10, scale: 2, default: 0.0, null: false
      t.decimal :outbound_rate, precision: 10, scale: 2, default: 0.0, null: false

      t.timestamps
    end

    add_index :rates, [ :project_id, :user_id ], unique: true
  end
end
