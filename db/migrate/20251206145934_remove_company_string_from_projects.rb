class RemoveCompanyStringFromProjects < ActiveRecord::Migration[8.0]
  def change
    remove_column :projects, :company, :string

    change_column_null :projects, :company_id, false
  end
end
