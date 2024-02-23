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
    Transaction.create!(invoice: @invoice_1, result: "success", credit_card_number: 5, credit_card_expiration_date: 7)
    Transaction.create!(invoice: @invoice_1, result: "success", credit_card_number: 5, credit_card_expiration_date: 7)
    Transaction.create!(invoice: @invoice_1, result: "success", credit_card_number: 5, credit_card_expiration_date: 7)
    Transaction.create!(invoice: @invoice_1, result: "success", credit_card_number: 5, credit_card_expiration_date: 7)

    Transaction.create!(invoice: @invoice_2, result: "success", credit_card_number: 5, credit_card_expiration_date: 7)
    Transaction.create!(invoice: @invoice_2, result: "success", credit_card_number: 5, credit_card_expiration_date: 7)

    Transaction.create!(invoice: @invoice_3, result: "success", credit_card_number: 5, credit_card_expiration_date: 7)
    Transaction.create!(invoice: @invoice_3, result: "success", credit_card_number: 5, credit_card_expiration_date: 7)
    Transaction.create!(invoice: @invoice_3, result: "success", credit_card_number: 5, credit_card_expiration_date: 7)
    Transaction.create!(invoice: @invoice_3, result: "success", credit_card_number: 5, credit_card_expiration_date: 7)

    Transaction.create!(invoice: @invoice_4, result: "success", credit_card_number: 5, credit_card_expiration_date: 7)

    Transaction.create!(invoice: @invoice_5, result: "success", credit_card_number: 5, credit_card_expiration_date: 7)
    Transaction.create!(invoice: @invoice_5, result: "success", credit_card_number: 5, credit_card_expiration_date: 7)
    Transaction.create!(invoice: @invoice_5, result: "success", credit_card_number: 5, credit_card_expiration_date: 7)

    visit "/admin"
  end

  describe "As an admin" do
    describe "User Story 19 - Admin Dashboard" do
      it "displays an 'Admin' page header" do
        expect(page).to have_content("Admin Dashboard")
      end
    end

    describe "User Story 20 - Admin Dashboard Links" do
      it "displays a merchant link"  do
        expect(page).to have_link("merchants")
        click_on "merchants"
        expect(current_path).to eq(admin_merchants_path)
      end

      it "displays a invoice link" do
        expect(page).to have_link("invoices")
        click_on "invoices"
        expect(current_path).to eq(admin_invoices_path)
      end
    end

    describe "User Story 21 - Top 5 Customers" do
      it "displays the top 5 customers" do
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

      it "lists top 5 customers from most successful transactions to least" do

        expect("First Customer").to appear_before("Third Customer")
        expect("Third Customer").to appear_before("Fifth Customer")
        expect("Fifth Customer").to appear_before("Second Customer")
        expect("Second Customer").to appear_before("Fourth Customer")

        Transaction.create!(invoice: @invoice_4, result: "success", credit_card_number: 5, credit_card_expiration_date: 7)
        Transaction.create!(invoice: @invoice_4, result: "success", credit_card_number: 5, credit_card_expiration_date: 7)

        visit "/admin"

        expect("First Customer").to appear_before("Third Customer")
        expect("Third Customer").to appear_before("Fourth Customer")
        expect("Fourth Customer").to appear_before("Fifth Customer")
        expect("Fifth Customer").to appear_before("Second Customer")
      end
    end

    describe "User Story 22 - Admin Dashboard Incomplete Invoices" do
      it "displays section header" do
        expect(page).to have_content("Incomplete Invoices")
      end

      it "lists invoices by id with unshipped items" do
        merchant_1 = create(:merchant)
        items = create_list(:item, 5, merchant: merchant_1)

        invoice_6 = create(:invoice, customer: @customer_5)
        invoice_7 = create(:invoice, customer: @customer_5)
        invoice_8 = create(:invoice, customer: @customer_5)
        invoice_9 = create(:invoice, customer: @customer_5)

        invoice_items_1 = create(:invoice_item, invoice: invoice_6)            # pending
        invoice_items_2 = create(:invoice_item, invoice: invoice_7)            # pending
        invoice_items_3 = create(:invoice_item, status: 1, invoice: invoice_8) # packaged
        invoice_items_4 = create(:invoice_item, status: 2, invoice: invoice_8) # shipped
        invoice_items_5 = create(:invoice_item, status: 2, invoice: invoice_9) # shipped

        visit "/admin"

        within "#invoice-#{invoice_6.id}" do
          expect(page).to have_content("Invoice ##{invoice_6.id}")
        end

        within "#invoice-#{invoice_7.id}" do
          expect(page).to have_content("Invoice ##{invoice_7.id}")
        end

        within "#invoice-#{invoice_8.id}" do
          expect(page).to have_content("Invoice ##{invoice_8.id}")
        end

        expect(page).to_not have_content("Invoice ##{invoice_9.id}")
      end

      it "invoice id links to that invoice's admin show page" do
        merchant_1 = create(:merchant)
        items = create_list(:item, 5, merchant: merchant_1)

        invoice_6 = create(:invoice, customer: @customer_5)
        invoice_7 = create(:invoice, customer: @customer_5)
        invoice_8 = create(:invoice, customer: @customer_5)
        invoice_9 = create(:invoice, customer: @customer_5)

        invoice_items_1 = create(:invoice_item, invoice: invoice_6)            # pending
        invoice_items_2 = create(:invoice_item, invoice: invoice_7)            # pending
        invoice_items_3 = create(:invoice_item, status: 1, invoice: invoice_8) # packaged
        invoice_items_4 = create(:invoice_item, status: 2, invoice: invoice_8) # shipped
        invoice_items_5 = create(:invoice_item, status: 2, invoice: invoice_9) # shipped

        visit "/admin"

        expect(page).to have_link("Invoice ##{invoice_6.id}")
        expect(page).to have_link("Invoice ##{invoice_7.id}")
        expect(page).to have_link("Invoice ##{invoice_8.id}")
        expect(page).to_not have_link("Invoice ##{invoice_9.id}")

        click_link "Invoice ##{invoice_6.id}"
        expect(current_path).to eq("/admin/invoices/#{invoice_6.id}")

        visit "/admin"
        click_link "Invoice ##{invoice_7.id}"
        expect(current_path).to eq("/admin/invoices/#{invoice_7.id}")
      end
    end

    describe "User Story 23 - Incomplete Invoices Sorted By Oldest to Newest" do
      it "displays the date that the invoice was made" do
        merchant_1 = create(:merchant)
        items = create_list(:item, 5, merchant: merchant_1)

        invoice_6 = create(:invoice, customer: @customer_5, created_at: "2011-09-13")
        invoice_7 = create(:invoice, customer: @customer_5, created_at: "2019-07-18")
        invoice_8 = create(:invoice, customer: @customer_5, created_at: "2023-06-23")
        invoice_9 = create(:invoice, customer: @customer_5, created_at: "2022-02-17")

        invoice_items_1 = create(:invoice_item, invoice: invoice_6)            # pending
        invoice_items_2 = create(:invoice_item, invoice: invoice_7)            # pending
        invoice_items_3 = create(:invoice_item, status: 1, invoice: invoice_8) # packaged
        invoice_items_4 = create(:invoice_item, status: 2, invoice: invoice_8) # shipped
        invoice_items_5 = create(:invoice_item, status: 2, invoice: invoice_9) # shipped

        visit "/admin"

        within "#invoice-#{invoice_6.id}" do
          expect(page).to have_content("Invoice ##{invoice_6.id} - Tuesday, September 13, 2011")
        end

        within "#invoice-#{invoice_7.id}" do
          expect(page).to have_content("Invoice ##{invoice_7.id} - Thursday, July 18, 2019")
        end

        within "#invoice-#{invoice_8.id}" do
          expect(page).to have_content("Invoice ##{invoice_8.id} - Friday, June 23, 2023")
        end

        expect(page).to_not have_content("Invoice ##{invoice_9.id} - Thursday, February 17, 2022")
      end

      it "Displays the order dates from oldest to newest" do
        merchant_1 = create(:merchant)
        items = create_list(:item, 5, merchant: merchant_1)

        invoice_6 = create(:invoice, customer: @customer_5, created_at: "2011-09-13")
        invoice_7 = create(:invoice, customer: @customer_5, created_at: "2019-07-18")
        invoice_8 = create(:invoice, customer: @customer_5, created_at: "2023-06-23")
        invoice_9 = create(:invoice, customer: @customer_5, created_at: "2022-02-17")

        invoice_items_1 = create(:invoice_item, invoice: invoice_6)            # pending
        invoice_items_2 = create(:invoice_item, invoice: invoice_7)            # pending
        invoice_items_3 = create(:invoice_item, status: 1, invoice: invoice_8) # packaged
        invoice_items_4 = create(:invoice_item, status: 2, invoice: invoice_8) # shipped
        invoice_items_5 = create(:invoice_item, status: 2, invoice: invoice_9) # shipped

        visit "/admin"

        expect("Invoice ##{invoice_6.id} - Tuesday, September 13, 2011").to appear_before("Invoice ##{invoice_7.id} - Thursday, July 18, 2019", only_text: true)
        expect("Invoice ##{invoice_7.id} - Thursday, July 18, 2019").to appear_before("Invoice ##{invoice_8.id} - Friday, June 23, 2023", only_text: true)

        invoice_10 = create(:invoice, customer: @customer_5, created_at: "2010-02-17")
        invoice_items_6 = create(:invoice_item, invoice: invoice_10)            # pending

        visit "/admin"
        save_and_open_page
        expect("Invoice ##{invoice_10.id} - Wednesday, February 17, 2010").to appear_before("Invoice ##{invoice_6.id} - Tuesday, September 13, 2011", only_text: true)
        expect("Invoice ##{invoice_6.id} - Tuesday, September 13, 2011").to appear_before("Invoice ##{invoice_7.id} - Thursday, July 18, 2019", only_text: true)
        expect("Invoice ##{invoice_7.id} - Thursday, July 18, 2019").to appear_before("Invoice ##{invoice_8.id} - Friday, June 23, 2023", only_text: true)
      end
    end
  end
end
