require 'rails_helper'

describe "Beers page" do
  let!(:brewery) {FactoryBot.create :brewery, name: "Koff"}

  it "Beer is added with a valid name" do
    visit new_beer_path
    fill_in('beer_name', with: 'Karhu')
    select('Lager', from: 'beer[style]')
    select('Koff', from: 'beer[brewery_id]')

    expect{
      click_button "Create Beer"
    }. to change{Beer.count}.from(0).to(1)
  end

  it "Beer without a valid name is not saved" do
    visit new_beer_path
    select('Lager', from: 'beer[style]')
    select('Koff', from: 'beer[brewery_id]')

    expect{
      click_button "Create Beer"
    }.to change{Beer.count}.by(0)
    expect(page).to have_content "Name can't be blank"
  end
end

