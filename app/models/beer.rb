class Beer < ApplicationRecord
  include RatingAverage

  belongs_to :brewery
  has_many :ratings, dependent: :destroy
  has_many :raters, -> { distinct }, through: :ratings, source: :user

  validates :name, presence: true

  def average
    # code here
    return 0 if ratings.empty?

    (ratings.map(&:score).sum / ratings.count.to_f).round(2)
  end

  def to_s
    "#{name} by #{brewery.name}"
  end
end
