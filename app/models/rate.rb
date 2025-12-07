class Rate < ApplicationRecord
  belongs_to :project
  belongs_to :user

  validates :user_id, uniqueness: { scope: :project_id, message: "Employee already has a rate for this project" }
  validates :inbound_rate, :outbound_rate, numericality: { greater_than_or_equal_to: 0 }
end
