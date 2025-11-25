class Worklog < ApplicationRecord

  belongs_to :project
  belongs_to :user
  belongs_to :submission, optional: true

  validates :hours, presence: true, numericality: { greater_than: 0 }

  validates :note, length: { minimum: 6 }

  validates :log_date, presence: true

  scope :not_submitted, -> { where(submission_id: nil) }

  scope :for_period, ->(start_date, end_date) {
    where(log_date: start_date..end_date)
  }

  def editable?
    submission_id.nil?
  end
end
