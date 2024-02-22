require "rails_helper"

RSpec.describe "Admin Dashboard", type: :feature do
  before do
    @customer_1 = Customer.create!(first_name: "First", last_name: "Customer")
    @customer_2 = Customer.create!(first_name: "Second", last_name: "Customer")
    @customer_3 = Customer.create!(first_name: "Third", last_name: "Customer")
    @customer_4 = Customer.create!(first_name: "Fourth", last_name: "Customer")
    @customer_5 = Customer.create!(first_name: "Fifth", last_name: "Customer")

    @invoice_1 = Invoice.create!(customer: @customer_1, status: 0)
    @invoice_2 = Invoice.create!(customer: @customer_2, status: 0)
    @invoice_3 = Invoice.create!(customer: @customer_3, status: 0)
    @invoice_4 = Invoice.create!(customer: @customer_4, status: 0)
    @invoice_5 = Invoice.create!(customer: @customer_5, status: 0)

    Transaction.create!(invoice: @invoice_1, result: "success", credit_card_number: 5, credit_card_expiration_date: 7)
    Transaction.create!(invoice: @invoice_2, result: "success", credit_card_number: 5, credit_card_expiration_date: 7)
    Transaction.create!(invoice: @invoice_3, result: "success", credit_card_number: 5, credit_card_expiration_date: 7)
    Transaction.create!(invoice: @invoice_4, result: "success", credit_card_number: 5, credit_card_expiration_date: 7)
    Transaction.create!(invoice: @invoice_5, result: "success", credit_card_number: 5, credit_card_expiration_date: 7)

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
    it "displays the top 5 customers" do      # When I visit the admin dashboard (/admin)
      # Then I see the names of the top 5 customers
      # who have conducted the largest number of successful transactions
      # And next to each customer name I see the number of successful transactions they have
      
      within "#customer-#{@customer_1.id}" do
        expect(page).to have_content(@customer_1.first_name)  
        expect(page).to have_content(@customer_1.last_name)  
        expect(page).to have_content(@customer_1.transaction_count)  
      end

      within "#customer-#{@customer_2.id}" do
        expect(page).to have_content(@customer_2.first_name)  
        expect(page).to have_content(@customer_2.last_name)  
        expect(page).to have_content(@customer_2.transaction_count)  
      end

      within "#customer-#{@customer_3.id}" do
        expect(page).to have_content(@customer_3.first_name)  
        expect(page).to have_content(@customer_3.last_name)  
        expect(page).to have_content(@customer_3.transaction_count)  
      end

      within "#customer-#{@customer_4.id}" do
        expect(page).to have_content(@customer_4.first_name)  
        expect(page).to have_content(@customer_4.last_name)  
        expect(page).to have_content(@customer_4.transaction_count)  
      end

      within "#customer-#{@customer_5.id}" do
        expect(page).to have_content(@customer_5.first_name)  
        expect(page).to have_content(@customer_5.last_name)  
        expect(page).to have_content(@customer_5.transaction_count)  
      end
    end
  end
end