class User < ApplicationRecord
  has_secure_password

  validates :first_name, :last_name, presence: true
  validates :email, format: { with: /\S+@\S+/ }, uniqueness: { case_sensitive: false }
end
