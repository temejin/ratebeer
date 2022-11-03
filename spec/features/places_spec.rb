require 'rails_helper'

describe "Places" do
  it "if one is returned by the API, it is shown at the page" do
    allow(BeermappingApi).to receive(:places_in).with("kumpula").and_return(
      [Place.new(name: "Oljenkorsi", id:1)]
    )
    allow(WeatherstackApi).to receive(:weather_in).with("kumpula").and_return(
      Weather.new(temperature: 20, wind_speed: 3, wind_dir: "SE", weather_icons: "")
    )

    visit places_path
    fill_in('city', with: 'kumpula')
    click_button "Search"

    expect(page).to have_content "Oljenkorsi"
  end

  it "if multiple are returned, all are shown on page" do
    names = ["paikka1", "paikka2", "paikka3"]
    places = []
    id = 1
    names.each do |name|
      allow(BeermappingApi).to receive(:places_in).with("kumpula").and_return(
          places << Place.new(name: name, id: id)
      )
      allow(WeatherstackApi).to receive(:weather_in).with("kumpula").and_return(
        Weather.new(temperature: 20, wind_speed: 3, wind_dir: "SE", weather_icons: "")
      )
      id += 1
    end

    visit places_path
    fill_in('city', with: 'kumpula')
    click_button "Search"

    names.each do |name|
      expect(page).to have_content(name)
    end
  end

  it "if none are found, and appropriate message is shown" do
    allow(BeermappingApi).to receive(:places_in).with("ankkalinna").and_return([])
    allow(WeatherstackApi).to receive(:weather_in).with("ankkalinna").and_return(
      nil
    )
    visit places_path
    fill_in('city', with: 'ankkalinna')
    click_button "Search"
    expect(page).to have_content("No locations in ankkalinna")
  end
end
