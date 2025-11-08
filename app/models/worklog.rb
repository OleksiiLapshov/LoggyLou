class Worklog < ApplicationRecord

  belongs_to :project
  belongs_to :user
  validates :hours, :note, :project, :log_date, presence: true

  belongs_to :submission, optional: true

  scope :not_submitted, -> { where(submission_id: nil) }

  scope :for_period, ->(month, year) {
    return none unless mpnth && year
    date = Date.new(year.to_i, month.to_1, 1)
    where(log_date: date.beginning_of_month..date.end_of_month)
  }

  def editable?
    submission_id.nil? || submission&.draft?
  end
end
