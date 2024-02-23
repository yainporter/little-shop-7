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
        within "#merchant-#{@merchant_1.id}" do
          expect(page).to have_content("Barry")
        end
        within "#merchant-#{@merchant_2.id}" do
          expect(page).to have_content("Sally")
        end 
        within "#merchant-#{@merchant_3.id}" do
          expect(page).to have_content("Beans")
        end
      end
    end
    
    describe "User Story 25 - Links to Admin Merchant Show Page" do
      it "displays links on each merchants name to admin merchant show page" do
        visit admin_merchants_path

        expect(page).to have_link("Barry")
        expect(page).to have_link("Sally")
        expect(page).to have_link("Beans")
    
        click_on "Barry"
    
        expect(current_path).to eq("admin/merchants/#{@merchant_1.id}")
        expect(current_path).to_not eq("admin/merchants/#{@merchant_2.id}")
        expect(page).to have_content("Barry")
        expect(page).to_not have_content("Sally")

        visit admin_merchants_path
        click_on "Sally"

        expect(current_path).to eq("admin/merchants/#{@merchant_2.id}")
        expect(current_path).to_not eq("admin/merchants/#{@merchant_3.id}")
        expect(page).to have_content("Sally")
        expect(page).to_not have_content("Beans")
      end
    end
  end
end