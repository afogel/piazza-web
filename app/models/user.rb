class User < ApplicationRecord
  has_many :memberships, dependent: :destroy
  has_many :organizations, through: :memberships
  has_many :app_sessions

  validates :name, presence: true
  validates :email,
    format: { with: URI::MailTo::EMAIL_REGEXP },
    uniqueness: { case_sensitive: false }

  has_secure_password
  validates :password,
    presence: true,
    length: { minimum: 8 }

  before_validation :strip_whitespace

  def authenticate_app_session(app_session_id, token)
    app_sessions.find(app_session_id).authenticate_token(token)
  rescue ActiveRecord::RecordNotFound
    nil
  end

  private

  def strip_whitespace
    self.name = self.name&.strip
    self.email = self.email&.strip
  end

  def self.create_app_session(email:, password:)
    return nil unless user = User.find_by(email: email.downcase)
    user.app_sessions.create if user.authenticate(password) 
  end
end