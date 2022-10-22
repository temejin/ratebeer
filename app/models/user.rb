class User < ApplicationRecord
  include RatingAverage

  has_secure_password

  validate :validate_password
  validates :username, uniqueness: true,
                       length: {minimum: 3,
                                maximum: 30}

  def validate_password
    if !password.match('[A-Z]+')
      errors.add(:password, "must contain at least one capital letter")
    end
    if !password.match('\d+')
      errors.add(:password, "must contain at least one number")
    end
    if password.length < 4
      errors.add(:password, "must be at least 4 characters long")
    end
  end

  has_many :ratings, dependent: :destroy
  has_many :beers, through: :ratings
  has_many :memberships, dependent: :destroy
  has_many :clubs, through: :memberships, source: :beer_club
end
