class User < ApplicationRecord
  has_secure_password
  has_many :schedules, dependent: :destroy
  has_many :student_actions, dependent: :destroy
  has_one :cohort
  validates :email, presence: true,
                    uniqueness: true
  validates :password, presence: true,
                       length: { within: 4..20 },
                       confirmation: true,
                       if: :password_digest_changed?

  def email=(value)
    value = value.strip.downcase
    write_attribute :email, value
  end

  # role-based authorization
  def student?
    role == 'student'
  end

  def admin?
    role == 'admin'
  end

  private

  # accepts a column name and uses secure random to genearate a random string as token and makes sure token is unique.
  def generate_token(column)
    loop do
      self[column] = SecureRandom.urlsafe_base64
      break unless User.exists?(column => self[column])
    end
  end
end
