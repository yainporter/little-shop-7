require 'rails_helper'

RSpec.describe 'Admin Merchants Show Page', type: :feature do
  describe 'As an Admin' do
    before(:each) do
      @merchant_1 = Merchant.create!(name: "Barry")
      @merchant_2 = Merchant.create!(name: "Sally")
      @merchant_3 = Merchant.create!(name: "Beans")
    end

    describe "User Story 25 - Admin Merchant Show Page" do
      it "creates links on each merchants name to show page" do
        visit admin_merchants_path

        click_on "Barry"

        expect(current_path).to eq("admin/merchants/#{@merchant_1.id}")
        expect(current_path).to_not eq("admin/merchants/#{@merchant_2.id}")
      end
    
      it "Displays Merchants name on show page" do
        visit admin_merchant_path

        expect(page).to have_content("Barry")
        expect(page).to_not have_content("Sally")
      end
    end


  end
end