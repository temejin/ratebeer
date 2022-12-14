require 'rails_helper'

include Helpers

describe "Rating" do
  let!(:brewery) { FactoryBot.create :brewery, name: "Koff" }
  let!(:beer1) { FactoryBot.create :beer, name: "iso 3", brewery:brewery }
  let!(:beer2) { FactoryBot.create :beer, name: "Karhu", brewery:brewery }
  let!(:user) { FactoryBot.create :user }

  before :each do
    sign_in(username: "Pekka", password: "Foobar1")
    visit ratings_path
  end

  it "when given, is registered to the beer and user who is signed in" do
    visit new_rating_path
    select('iso 3', from: 'rating[beer_id]')
    fill_in('rating[score]', with: '15')

    expect{
      click_button "Create rating"
    }.to change{Rating.count}.from(0).to(1)

    expect(user.ratings.count).to eq(1)
    expect(beer1.ratings.count).to eq(1)
    expect(beer1.average_rating).to eq(15.0)
  end

  it "displays recent ratings" do
    scores = [10, 15, 11]
    scores.each do |score|
      FactoryBot.create(:rating, score: score, user: user)
    end
    visit ratings_path
    expect(page).to have_content "Recent ratings"
    scores.each do |score|
      expect(page).to have_content "#{score}"
    end
  end

  it "displays top beers" do
    expect(page).to have_content "Top beers"
  end

  it "displays top breweries" do
    expect(page).to have_content "Top breweries"
  end

  it "displays top styles" do
    expect(page).to have_content "Top styles"
  end

  it "displays most active users" do
    expect(page).to have_content "Most active users"
  end
end

