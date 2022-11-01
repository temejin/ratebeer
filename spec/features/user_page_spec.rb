require 'rails_helper'

include Helpers

describe "User" do
  before :each do
    @user = FactoryBot.create :user
  end

  describe "who has signed up" do
    it "can signin with right credentials" do
      sign_in(username: "Pekka", password: "Foobar1")

      expect(page).to have_content 'Welcome back!'
      expect(page).to have_content 'Pekka'
    end

    it "is redirected back to signin form if wrong credentials given" do
      sign_in(username: "Pekka", password: "Wrong")

      expect(current_path).to eq(signin_path)
      expect(page).to have_content 'Username and/or password mismatch'
    end

    it "when signed up with good credentials, is added to the system" do
      visit signup_path
      fill_in('user_username', with: 'Brian')
      fill_in('user_password', with: 'Secret55')
      fill_in('user_password_confirmation', with: 'Secret55')

      expect{
        click_button('Create User')
      }.to change{User.count}.by(1)
    end
  end

  describe "who has made ratings" do
    let!(:user2){ FactoryBot.create(:user, username: "Kalle") }
    before :each do
      scores = [10, 30, 35]
      scores.each do |score|
        FactoryBot.create(:rating, score: score, user: @user)
      end
      visit user_path(@user)
    end

    it "has their ratings listed on its page" do
      scores = [10, 30, 35]
      scores.each do |score|
        FactoryBot.create(:rating, score: score + 1, user: user2)
      end
      scores.each do |score|
        expect(page).to have_content "#{score}"
        expect(page).not_to have_content "#{score + 1}"
      end
      expect(Rating.count).to eq(6)
    end

    it "has their rating removed upon clicking the delete button" do
      sign_in(username: "Pekka", password: "Foobar1")
      a = page.all('a', text: 'Delete')
      expect{
        a[1].click
      }.to change{Rating.count}.by(-1)
      expect(page).not_to have_content "30"
    end

    it "has their favourite style and brewery displayed" do
      expect(page).to have_content("Favourite style: #{@user.favorite_style.name}")
      expect(page).to have_content("Favourite brewery: #{@user.favorite_brewery.name}")
    end
  end
end
