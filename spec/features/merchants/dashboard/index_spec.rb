require "rails_helper"

RSpec.describe "Merchant Dashboard" do
  before do
    @merchant_1 = Merchant.create!(name: "Barry")

    visit "/merchants/#{@merchant_1.id}/dashboard"
  end

  describe "User Story 1 - Merchant Dashboard" do
    it "displays merchant name" do
      expect(page).to have_content("Barry's Dashboard")
    end
  end
end