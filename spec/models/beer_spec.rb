require 'rails_helper'

RSpec.describe Beer, type: :model do
  let(:test_brewery) { Brewery.new name: "test", year: 2000 }
  let(:test_style) { Style.new }
  it "is saved when name, style and brewery are set" do
    beer = Beer.create name: "testbeer", brewery: test_brewery, style: test_style

    expect(beer).to be_valid
    expect(Beer.count).to eq(1)
  end

  describe "is not saved when" do
    it "name is not set" do
      beer = Beer.create brewery: test_brewery, style: test_style

      expect(beer).not_to be_valid
    end

    it "style is not set" do
      beer = Beer.create name: "testbeer", brewery: test_brewery

      expect(beer).not_to be_valid
    end
  end
end
