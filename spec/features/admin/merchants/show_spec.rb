require "rails_helper"

RSpec.describe "Admin Merchant Show", type: :feature do
  describe "As an Admin" do
    before do
      @merchant_1 = Merchant.create!(name: "The Best Merchant")
    end

    describe "User Story 26 - Admin Merchant Update" do
      it "Displays a link to edit merchant page" do
        visit admin_merchant_path(@merchant_1) 

        expect(page).to have_link("Update Merchant")
        
        click_on "Update Merchant"

        expect(current_path).to eq(edit_admin_merchant_path(@merchant_1))
      end
    end
  end
end