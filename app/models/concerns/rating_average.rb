module RatingAverage
  extend ActiveSupport::Concern

  def average_rating
    if self.ratings.empty?
      return nil
    end
    r = []
    self.ratings.each do |rate|
      r << rate.score
    end
    return (r.inject(0.0, :+) / r.count).round(2)
  end
end
