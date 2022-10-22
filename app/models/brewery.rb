class Brewery < ApplicationRecord
  include RatingAverage

  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers

  validate :year_not_greater_than_current
  validates :name, presence: true
  validates :year, numericality: { greater_than_or_equal_to: 1040,
                                   only_integer: true }

  def year_not_greater_than_current
    errors.add(:year, "can't be greater than current year") if year > Time.now.year
  end

  def print_report
    puts name
    puts "established at year #{year}"
    puts "number of beers #{beers.count}"
  end

  def restart
    self.year = 2022
    puts "changed year to #{year}"
  end
end
