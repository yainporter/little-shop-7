require 'rails_helper'

RSpec.describe 'Admin Merchants Index Page', type: :feature do
  describe 'As an Admin' do
    before(:each) do
      @merchant_1 = Merchant.create!(name: "Barry", status: 1)
      @merchant_2 = Merchant.create!(name: "Sally", status: 0)
      @merchant_3 = Merchant.create!(name: "Beans", status: 1)
    end

    describe "User Story 24 - Admin Merchants Index" do 
      it 'displays the names of all the merchants' do
        visit admin_merchants_path

        expect(page).to have_content("Barry")
        expect(page).to have_content("Sally")
        expect(page).to have_content("Beans")
      end
    end
    
    describe "User Story 25 - Links to Admin Merchant Show Page" do
      it "displays links on each merchants name to admin merchant show page" do
        visit admin_merchants_path

        expect(page).to have_link("Barry")
        expect(page).to have_link("Sally")
        expect(page).to have_link("Beans")
    
        click_on "Barry"
    
        expect(current_path).to eq("/admin/merchants/#{@merchant_1.id}")
        expect(current_path).to_not eq("/admin/merchants/#{@merchant_2.id}")
        expect(page).to have_content("Barry")
        expect(page).to_not have_content("Sally")

        visit admin_merchants_path
        click_on "Sally"

        expect(current_path).to eq("/admin/merchants/#{@merchant_2.id}")
        expect(current_path).to_not eq("/admin/merchants/#{@merchant_3.id}")
        expect(page).to have_content("Sally")
        expect(page).to_not have_content("Beans")
      end
    end

    describe "User Story 27/28 - Admin Merchant enable/disable" do 
      it "Displays each merchant in 'Enabled Merchants' group w/a disable button" do
        visit admin_merchants_path
        
        within "#enabled-merchants" do
          expect(page).to have_button("Disable")
          expect(page).to_not have_button("Enable")
          expect(page).to have_content("Sally")
        
          click_button "Disable"
        end
        expect(current_path).to eq(admin_merchants_path)
        
        within "#disabled-merchants" do
          expect(page).to have_content("Sally")
          expect(page).to have_button("Enable")
          expect(page).to_not have_button("Disable")
        end
    
        within "#enabled-merchants" do
          expect(page).to_not have_content("Sally")
        end
      end
      
      it "Displays each merchant in 'Disabled Merchants' group w/an enable button" do
        visit admin_merchants_path
      
        within "#disabled-merchants" do
          expect(page).to have_button("Enable", count: 2)
          expect(page).to_not have_button("Disable")
          expect(page).to have_content("Barry")
        
          click_button "Enable", match: :first
        end
        
        expect(current_path).to eq(admin_merchants_path)
      
        within "#enabled-merchants" do
          expect(page).to have_content("Barry")
          expect(page).to have_button("Disable")
          expect(page).to_not have_button("Enable")
        end
      
        within "#disabled-merchants" do
          expect(page).to_not have_content("Barry")
        end
      end
    end

    describe "User Story 29 - Admin Merchant Create" do
      it "displays link to create a new merchant" do
        visit admin_merchants_path

        expect(page).to have_link("New Merchant")

        click_on "New Merchant"

        expect(current_path).to eq(new_admin_merchant_path)
      end
    end
  end
end
