require "rails_helper"

RSpec.describe "Admin Dashboard", type: :feature do
  describe "As a visitor" do
    before do
      visit "/admin"
    end

    it "displays an 'Admin' page header" do
      expect(page).to have_content("Admin Dashboard")
    end
  end
end