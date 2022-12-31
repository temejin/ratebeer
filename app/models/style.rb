class Style < ApplicationRecord
  include RatingAverage

  has_many :beers
  has_many :ratings, through: :beers

  def self.top(number)
    Style.all.sort_by(&:average_rating).reverse.take(number)
  end
end
