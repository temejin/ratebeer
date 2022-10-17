class Beer < ApplicationRecord
  include RatingAverage

  belongs_to :brewery
  has_many :ratings, dependent: :destroy

  def average
    # code here
    return 0 if ratings.empty?

    (ratings.map(&:score).sum / ratings.count.to_f).round(2)
  end

  def to_s
    "#{name} by #{brewery.name}"
  end
end
