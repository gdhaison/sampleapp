class User < ApplicationRecord
  USER_PARAMS = %i(name email password password_confirmation).freeze

  attr_accessor :remember_token, :activation_token
  before_create :create_activation_digest
  before_save :downcase_email

  validates :name, presence: true,
    length: {maximum: Settings.user_name_length_max}
  validates :email, presence: true,
    length: {maximum: Settings.user_email_length_max},
    format: {with: Settings.valid_email}, uniqueness: {case_sensitive: false}
  validates :password, presence: true,
    length: {minimum: Settings.user_pass_length_min}
  has_secure_password

  scope :order_user, ->{order created_at: :desc}
  scope :activated, ->{where activated: true}

  class << self
    def digest string
      cost = if ActiveModel::SecurePassword.min_cost
               BCrypt::Engine::MIN_COST
             else
               BCrypt::Engine.cost
             end
      BCrypt::Password.create string, cost: cost
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def remember
    self.remember_token = User.new_token
    update_attribute :remember_digest, User.digest(remember_token)
  end

  def authenticated? attribute, token
    digest = send "#{attribute}_digest"

    return false unless !digest.nil?
    BCrypt::Password.new(digest).is_password? token
  end

  def forget
    update_attribute :remember_digest, nil
  end

  def activate
    update_attributes activated: true, activated_at: Time.zone.now
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  private

  def downcase_email
    email.downcase!
  end

  def create_activation_digest
    self.activation_token  = User.new_token
    self.activation_digest = User.digest activation_token
  end
end
