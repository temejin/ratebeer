class BeerClub < ApplicationRecord
  has_many :memberships, dependent: :destroy
  has_many :members, through: :memberships, source: :user

  validates :name, presence: true

  def to_s
    name
  end
end
