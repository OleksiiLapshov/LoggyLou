class Submission < ApplicationRecord
  belongs_to :user
  has_many :worklogs, dependent: :nullify
end
