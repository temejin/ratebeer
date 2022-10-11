class Beer < ApplicationRecord
  belongs_to :brewery
  has_many :ratings

  def average_rating
    if self.ratings.empty?
      return nil
    end
    sum = 0
    self.ratings.each do |rate|
      sum += rate.score
    end
    avg = sum / self.ratings.count
    return avg.to_f
  end
end
