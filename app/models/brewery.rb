class Brewery < ApplicationRecord
  include RatingAverage

  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers

  validate :validate_year
  validates :name, presence: true

  def validate_year
    if !year
      errors.add(:year, "can't be blank")
    elsif year.is_a? Integer
      if year > Time.now.year
        errors.add(:year, "cannot be in the future")
      elsif year < 1040
        errors.add(:year, "must be greater than or equal to 1040")
      end
    else
      errors.add(:year, "must be an integer between 1040 and #{Time.now.year}")
    end
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
