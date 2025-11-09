class Submission < ApplicationRecord
  belongs_to :user
  has_many :worklogs, dependent: :nullify

  enum :status, { draft: 0, approved: 1, rejected: 2 }

  validates :user_id, uniqueness: { scope: [ :period_start, :period_end, :id ] }
end
