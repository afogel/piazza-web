class User < ApplicationRecord
  has_many :memberships, dependent: :destroy
  has_many :organizations, through: :memberships

  validates :name, presence: true
  validates :email,
    format: { with: URI::MailTo::EMAIL_REGEXP },
    uniqueness: { case_sensitive: false }

  has_secure_password
  validates :password,
    presence: true,
    length: { minimum: 8 }

  before_validation :strip_whitespace

  private

  def strip_whitespace
    self.name = self.name&.strip
    self.email = self.email&.strip
  end
end
