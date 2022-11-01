require 'rails_helper'
include Helpers

describe "Beers page" do
  let!(:brewery) {FactoryBot.create :brewery, name: "Koff"}
  let!(:user){ FactoryBot.create :user }
  let!(:style) {FactoryBot.create :style }

  before :each do
    sign_in(username: "Pekka", password: "Foobar1")
  end

  it "Beer is added with a valid name" do
    visit new_beer_path
    fill_in('beer_name', with: 'Karhu')
    select('Lager', from: 'beer[style_id]')
    select('Koff', from: 'beer[brewery_id]')

    expect{
      click_button "Create Beer"
    }. to change{Beer.count}.from(0).to(1)
  end

  it "Beer without a valid name is not saved" do
    visit new_beer_path
    select('Lager', from: 'beer[style_id]')
    select('Koff', from: 'beer[brewery_id]')

    expect{
      click_button "Create Beer"
    }.to change{Beer.count}.by(0)
    expect(page).to have_content "Name can't be blank"
  end
end

