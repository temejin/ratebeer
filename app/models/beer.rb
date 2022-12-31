class Beer < ApplicationRecord
  include RatingAverage

  belongs_to :brewery
  belongs_to :style
  has_many :ratings, dependent: :destroy
  has_many :raters, -> { distinct }, through: :ratings, source: :user

  validates :name, presence: true
  validates :brewery, presence: true
  validates :style, presence: true

  def average
    # code here
    return 0 if ratings.empty?

    (ratings.map(&:score).sum / ratings.count.to_f).round(2)
  end

  def to_s
    "#{name} by #{brewery.name}"
  end

  def self.top(number)
    Beer.all.sort_by(&:average_rating).reverse.take(number)
  end
end
