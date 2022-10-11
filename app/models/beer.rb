class Beer < ApplicationRecord
  belongs_to :brewery
  has_many :ratings

  def average_rating
    if self.ratings.empty?
      return nil
    end
    r = []
    self.ratings.each do |rate|
      r << rate.score
    end
    return r.inject(0.0, :+) / r.count
  end
end
