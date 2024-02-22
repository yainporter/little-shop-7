require "rails_helper"

RSpec.describe "Admin Dashboard", type: :feature do
  before do
    # As an Admin
    # When I visit the admin dashboard (/admin)
    visit "/admin"
  end

  describe "As an admin" do
    
    # 19. Admin Dashboard
    it "displays an 'Admin' page header" do
      # Then I see a header indicating that I am on the admin dashboard
      expect(page).to have_content("Admin Dashboard")
    end
  end

  #20. Admin Dashboard Links
  describe "page links" do
    # Then I see a link to the admin merchants index (/admin/merchants)
    it "displays a merchant link"  do
      expect(page).to have_link("merchants")
      click_on "merchants"
      expect(current_path).to eq(admin_merchants_path)
    end

    # And I see a link to the admin invoices index (/admin/invoices)
    it "displays a invoice link" do
      expect(page).to have_link("invoices")
      click_on "invoices"
      expect(current_path).to eq(admin_invoices_path)
    end
  end

  # 21. Admin Dashboard Statistics - Top Customers
  describe "Dashboard Stats - Top Customers" do 
    before(:each) do
      @customer_1 = Customer.create(:customer)
      @customer_2 = Customer.create(:customer)
      @customer_3 = Customer.create(:customer)
      @customer_4 = Customer.create(:customer)
      @customer_5 = Customer.create(:customer)
    end
    
    it "displays the top 5 customers" do
      # When I visit the admin dashboard (/admin)
      # Then I see the names of the top 5 customers
      # who have conducted the largest number of successful transactions
      # And next to each customer name I see the number of successful transactions they have
      within "#customer-#{@customer_1.id}" do
        expect(page).to have_content(@customer_1.name)  
        expect(page).to have_content(@customer_1.transaction_count)  
      end
      # expect(page).to have_content(@customer_2.name)  
      # expect(page).to have_content(@customer_3.name)  
      # expect(page).to have_content(@customer_4.name)  
      # expect(page).to have_content(@customer_5.name)  
      # conducted 
    end
  end
end