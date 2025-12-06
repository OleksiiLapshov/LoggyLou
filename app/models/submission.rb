class Submission < ApplicationRecord
  belongs_to :user
  has_many :worklogs, dependent: :nullify

  enum :status, { draft: 0, approved: 1, rejected: 2 }

  validates :user_id, uniqueness: { scope: [ :period_start, :period_end, :id ] }

  def chart_data
    logs = worklogs.order(log_date: :asc)

    hours_by_date = logs.group(:log_date).sum(:hours)

    (period_start..period_end).each_with_object({}) do |date, hash|
      hash[date] = hours_by_date[date] || 0
    end
  end
end
