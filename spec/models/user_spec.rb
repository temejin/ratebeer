require 'rails_helper'

RSpec.describe User, type: :model do
  it "has the username set correctly" do
    user = User.new username: "Pekka"

    expect(user.username).to eq("Pekka")
  end

  it "is not saved without a password" do
    user = User.create username: "Pekka"

    expect(user.valid?).to be(false)
    expect(User.count).to eq(0)
  end

  describe "with a proper password" do
    let(:user) { FactoryBot.create(:user) }

    it "is saved" do
      expect(user).to be_valid
      expect(User.count).to eq(1)
    end

    it "and with two ratings, has the correct average rating" do
      FactoryBot.create(:rating, score: 10, user: user)
      FactoryBot.create(:rating, score: 20, user: user)

      expect(user.ratings.count).to eq(2)
      expect(user.average_rating).to eq(15.0)
    end
  end

  describe "is not saved when" do
    it "password is too short" do
      user = User.create username: "Pekka", password: "As1", password_confirmation: "As1"

      expect(user).not_to be_valid
      expect(User.count).to eq(0)
    end

    it "password only contains lower case letters" do
      user = User.create username: "Pekka", password: "secret", password_confirmation: "secret"

      expect(user).not_to be_valid
      expect(User.count).to eq(0)
    end
  end

  describe "favorite beer" do
    let(:user){ FactoryBot.create(:user) }
    let(:style){ FactoryBot.create(:style) }

    it "has method for determining one" do
      expect(user).to respond_to(:favorite_beer)
    end

    it "without ratings does not have one" do
      expect(user.favorite_beer).to eq(nil)
    end

    it "is the only rated if only one rating" do
      beer = FactoryBot.create(:beer)
      rating = FactoryBot.create(:rating, score: 20, beer: beer, user: user)

      expect(user.favorite_beer).to eq(beer)
    end

    it "is the one with highest rating if several rated" do
      create_beers_with_many_ratings({ user: user }, style, 10, 20, 15, 7, 9)
      best = create_beer_with_rating({ user: user }, style, 25)

      expect(user.favorite_beer).to eq(best)
    end
  end

  describe "favorite style" do
    let(:user){ FactoryBot.create(:user) }
    let(:style){ FactoryBot.create(:style) }
    it "has method for determining one" do
      expect(user).to respond_to(:favorite_style)
    end

    it "without ratings does not have one" do
      expect(user.favorite_style).to eq(nil)
    end

    it "is the only rated if only one rating" do
      beer = create_beer_with_rating({ user: user }, style, 20)
      expect(user.favorite_style.name).to eq("Lager")
    end

    it "is the style with the highest average if multiple rated" do
      ipa = FactoryBot.create(:style, name: "IPA")
      porter = FactoryBot.create(:style, name: "Porter")
      create_beers_with_many_ratings({ user: user }, style, 10, 20, 30)
      create_beers_with_many_ratings({ user: user }, porter, 30, 40, 50)
      create_beers_with_many_ratings({ user: user }, ipa, 20, 25, 30)

      expect(user.favorite_style.name).to eq("Porter")
    end
  end

  describe "favorite brewery" do
    let(:user){ FactoryBot.create(:user) }
    let(:style){ FactoryBot.create(:style) }
    it "has method for determining one" do
      expect(user).to respond_to(:favorite_style)
    end

    it "without ratings does not have one" do
      expect(user.favorite_brewery).to eq(nil)
    end

    it "is the only with a rated beer if only one rating" do
      create_beer_with_rating({ user: user }, style, 20)
      expect(user.favorite_brewery.name).to eq("anonymous")
    end

    it "is the brewery with highest average when multiple are rated" do
      brewery1 = FactoryBot.create(:brewery, name: "panimo1")
      brewery2 = FactoryBot.create(:brewery, name: "panimo2")
      brewery3 = FactoryBot.create(:brewery, name: "panimo3")

      create_beers_for_brewery({ user: user }, { brewery: brewery1 }, 10, 20, 30)
      create_beers_for_brewery({ user: user }, { brewery: brewery3 }, 20, 20, 30)
      create_beers_for_brewery({ user: user }, { brewery: brewery2 }, 30, 35, 40)

      expect(user.favorite_brewery.name).to eq("panimo2")
    end
  end
end

def create_beer_with_rating(object, style, score)
  beer = FactoryBot.create(:beer, style: style)
  FactoryBot.create(:rating, beer: beer, score: score, user: object[:user])
  beer
end

def create_beers_with_many_ratings(object, style, *scores)
  scores.each do |score|
    create_beer_with_rating(object, style, score)
  end
end

def create_beers_for_brewery(user, brewery, *scores)
  scores.each do |score|
    create_beer_with_rating_and_brewery(user, brewery, score)
  end
end

def create_beer_with_rating_and_brewery(user, brewery, score)
  beer = FactoryBot.create(:beer, brewery: brewery[:brewery])
  FactoryBot.create(:rating, beer: beer, score: score, user: user[:user])
  beer
end
