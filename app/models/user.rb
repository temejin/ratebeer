class User < ApplicationRecord
  include RatingAverage

  has_secure_password

  validates :password, length: { minimum: 4 },
                       format: { with: /\A[A-Z].*\d|\d.*[A-Z]\z/, message: "must include one upper case letter and number" }
  validates :username, uniqueness: true,
                       length: { minimum: 3,
                                 maximum: 30 }

  has_many :ratings, dependent: :destroy
  has_many :beers, through: :ratings
  has_many :memberships, dependent: :destroy
  has_many :clubs, through: :memberships, source: :beer_club

  def favorite_beer
    return nil if ratings.empty?

    ratings.order(score: :desc).limit(1).first.beer
  end

  def favorite_style
    return nil if ratings.empty?

    rated_styles = beers.map(&:style).uniq
    avgs = rated_styles.map { |style| style_average(style) }
    avgs.max_by { |avg| avg[1] }[0]
  end

  def style_average(style)
    rates = ratings.select{ |r| r.beer.style == style }
    scores = rates.map(&:score)
    avg = scores.sum / scores.count
    [style, avg]
  end

  def favorite_brewery
    return nil if ratings.empty?

    rated_breweries = beers.map(&:brewery).uniq
    avgs = rated_breweries.map { |b| brewery_average(b) }
    avgs.max_by { |avg| avg[1] }[0]
  end

  def brewery_average(brewery)
    rates = ratings.select{ |r| r.beer.brewery == brewery }
    scores = rates.map(&:score)
    avg = scores.sum / scores.count
    [brewery, avg]
  end
end
