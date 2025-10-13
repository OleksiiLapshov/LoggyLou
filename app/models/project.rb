class Project < ApplicationRecord
  has_many :worklogs, dependent: :destroy
  has_many :assignments, dependent: :destroy

  validates :name, :company, presence: true
end
