class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :name, presence: true,
    length: {maximum: Settings.user_name_length_max}
  validates :email, presence: true,
    length: {maximum: Settings.user_email_length_max},
    format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}
  validates :password, presence: true,
    length: {minimum: Settings.user_pass_length_min}
  before_save :downcase_email
  has_secure_password
  USER_PARAMS = %i(name email password password_confirmation).freeze

  def self.digest string
    cost = if ActiveModel::SecurePassword.min_cost
             BCrypt::Engine::MIN_COST
           else
             BCrypt::Engine.cost
           end
    BCrypt::Password.create string, cost: cost
  end

  private

  def downcase_email
    email.downcase!
  end
end
