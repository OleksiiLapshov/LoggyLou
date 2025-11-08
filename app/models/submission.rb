class Submission < ApplicationRecord
  belongs_to :user
  has_many :worklogs, dependent: :nullify

  enum :status, { draft: 0, approved: 1, rejected: 2 }
end
