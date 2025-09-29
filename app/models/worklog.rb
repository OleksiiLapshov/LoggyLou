class Worklog < ApplicationRecord

  belongs_to :project
  belongs_to :user
  validates :hours, :note, :project, :log_date, presence: true

end
