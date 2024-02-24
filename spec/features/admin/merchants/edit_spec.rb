require "rails_helper"

RSpec.describe "Admin Merchant Edit", type: :feature do
  describe "As an Admin" do
    before do
      @merchant_1 = Merchant.create!(name: "The Best Merchant")
    end

    describe "User Story 26 - Admin Merchant Update" do
      it "Displays update form with current merchant info" do
        visit edit_admin_merchant_path(@merchant_1)

        expect(page.find_field("Name").value).to eq("The Best Merchant")
      end

      it "updated form redirects to Merchant's Admin Show and shows flash method" do
        visit edit_admin_merchant_path(@merchant_1)
        fill_in "Name", with: "The Very Best Merchant"
        click_on "Submit"

        expect(current_path).to eq(admin_merchant_path(@merchant_1))
        expect(page).to have_content("The Very Best Merchant")
        expect(page).to_not have_content("The Best Merchant")
        expect(page).to have_content("The Very Best Merchant Successfully Updated!")
      end
    end
  end
end