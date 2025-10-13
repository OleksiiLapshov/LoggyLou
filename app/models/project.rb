class Project < ApplicationRecord
  has_many :worklogs, dependent: :destroy
  has_many :assignments, dependent: :destroy

  has_many :users, through: :assignments, source: :user

  validates :name, :company, presence: true
end
