class CreateCompanies < ActiveRecord::Migration[8.0]
  def change
    create_table :companies do |t|
      t.string :name
      t.string :address_line_1
      t.string :address_line_2
      t.string :postcode
      t.string :city
      t.string :country
      t.string :vat
      t.string :account_number
      t.string :contact_phone
      t.string :contact_email
      t.string :contact_person

      t.timestamps
    end
  end
end
