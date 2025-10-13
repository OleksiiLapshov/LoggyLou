class User < ApplicationRecord
  has_secure_password

  has_many :worklogs, dependent: :destroy
  has_many :assignments, dependent: :destroy

  has_many :projects, through: :assignments, source: :project

  validates :first_name, :last_name, presence: true
  validates :email, format: { with: /\S+@\S+/ }, uniqueness: { case_sensitive: false }
end
