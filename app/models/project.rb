class Project < ApplicationRecord
  has_many :worklogs, dependent: :destroy

  validates :name, :company, presence: true
end
