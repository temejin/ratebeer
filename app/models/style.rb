class Style < ApplicationRecord
  include RatingAverage

  has_many :beers
  has_many :ratings, through: :beers

  def self.top(n)
    Style.all.sort_by(&:average_rating).reverse.take(n)
  end
end
