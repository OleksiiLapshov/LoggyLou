class MigrateCompanyData < ActiveRecord::Migration[8.0]
  class Project < ActiveRecord::Base; end
  class Company < ActiveRecord::Base; end

  def up
    unique_names = Project.where.not(company: nil).distinct.pluck(:company)

    unique_names.each do |name|
      new_company = Company.find_or_create_by!(name: name.strip)

      Project.where(company: name).update_all(company_id: new_company.id)
    end
  end

  def down
    Project.where.not(company_id: nil).find_each do |project|
      company_name = Company.find(project.company_id).name
      project.update(company: company_name)
    end
  end
end
