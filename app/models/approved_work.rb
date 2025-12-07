class ApprovedWork < ApplicationRecord
  belongs_to :submission
  belongs_to :project
  belongs_to :user
end
