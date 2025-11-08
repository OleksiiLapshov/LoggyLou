class Worklog < ApplicationRecord

  belongs_to :project
  belongs_to :user
  validates :hours, :note, :project, :log_date, presence: true

  belongs_to :submission, optional: true

  scope :not_submitted, -> { where(submission_id: nil) }

  scope :for_period, ->(start_date, end_date) {
    where(log_date: start_date..end_date)
  }

  def editable?
    submission_id.nil? || submission&.draft?
  end
end
