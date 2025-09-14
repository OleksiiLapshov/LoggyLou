class Worklog < ApplicationRecord

  belongs_to :project
  validates :employee, :hours, :note, :project, :log_date, presence: true

end
