require 'rails_helper'

RSpec.describe 'Admin Merchants Index Page', type: :feature do
  describe 'As an Admin' do
    before(:each) do
      @merchant_1 = Merchant.create!(name: "Barry")
      @merchant_2 = Merchant.create!(name: "Sally")
      @merchant_3 = Merchant.create!(name: "Beans")
    end

    describe "User Story 24 - Admin Merchants Index" do 
      it 'displays the names of all the merchants' do
        # When I visit the admin merchants index (/admin/merchants)
        visit admin_merchants_path
        # Then I see the name of each merchant in the system
        within "#merch-#{@merchant_1.id}" do
          expect(page).to have_content("Barry")
        end
        within "#merch-#{@merchant_2.id}" do
          expect(page).to have_content("Sally")
        end 
        within "#merch-#{@merchant_3.id}" do
          expect(page).to have_content("Beans")
        end
      end
    end
  end
end
