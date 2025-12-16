class User < ApplicationRecord
  has_secure_password

  has_many :worklogs, dependent: :destroy
  has_many :assignments, dependent: :destroy

  has_many :projects, through: :assignments, source: :project
  has_many :submissions, dependent: :destroy
  has_many :rates

  validates :first_name, :last_name, presence: true
  validates :email, format: { with: /\S+@\S+/ }, uniqueness: { case_sensitive: false }
  validates :notification_email, format: { with: /\S+@\S+/ }, uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 8 }, allow_nil: true
  validate :password_complexity

  def full_name
    "#{first_name} #{last_name}".strip
  end


  private

  def password_complexity
    # skip validation if there is no password (on update)
    return if password.blank?

    # check for uppercase
    unless password.match?(/[A-Z]/)
      errors.add :password, "must include at least one uppercase letter"
    end

    # check for lowercase
    unless password.match?(/[a-z]/)
      errors.add :password, "must include at least one lowercase letter"
    end

    # check for digits
    unless password.match?(/[0-9]/)
      errors.add :password, "must include at least one digit"
    end

    # check for special characters
    # crutch to avoid whitelist: this regex looks for anything that is NOT a letter or number
    unless password.match?(/[^a-zA-Z0-9]/)
      errors.add :password, "must include at least one special character"
    end
  end
end
