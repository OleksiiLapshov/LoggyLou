class Project < ApplicationRecord
  has_many :worklogs, dependent: :destroy
  has_many :assignments, dependent: :destroy
  belongs_to :company

  has_many :users, through: :assignments, source: :user

  validates :name, :company_id, presence: true
end
