require 'rails_helper'

RSpec.describe 'Admin Merchants Index Page', type: :feature do
  describe 'As an Admin' do
    before do
      @merchant_1 = Merchant.create!(name: "Barry", status: 1)
      @merchant_2 = Merchant.create!(name: "Sally", status: 0)
      @merchant_3 = Merchant.create!(name: "Rayla", status: 1)
      @merchant_4 = Merchant.create!(name: "Beans", status: 1)
      @merchant_5 = Merchant.create!(name: "Greens", status: 1)
      @merchant_6 = Merchant.create!(name: "Potatoes", status: 0)
      @merchant_7 = Merchant.create!(name: "Chicken", status: 1)
      @merchant_8 = Merchant.create!(name: "Lamb", status: 1)
      @merchant_9 = Merchant.create!(name: "You Name IT!!!!", status: 1)

      @customer_1 = build(:customer)

      @item_4 = create(:item, merchant: @merchant_4)
      @item_5 = create(:item, merchant: @merchant_5)
      @item_6 = create(:item, merchant: @merchant_6)
      @item_7 = create(:item, merchant: @merchant_7)
      @item_8 = create(:item, merchant: @merchant_8)
      @item_9 = create(:item, merchant: @merchant_9)

      @invoice_1 = create(:invoice, customer: @customer_1, created_at: "2015-12-09")
      @invoice_2 = create(:invoice, customer: @customer_1, created_at: "2013-11-10")
      @invoice_3 = create(:invoice, customer: @customer_1, created_at: "2022-03-08")
      @invoice_4 = create(:invoice, customer: @customer_1, created_at: "2023-05-19")
      @invoice_5 = create(:invoice, customer: @customer_1, created_at: "2024-01-23")
      @invoice_6 = create(:invoice, customer: @customer_1, created_at: "2001-01-01")
      @invoice_7 = create(:invoice, customer: @customer_1, created_at: "2184-10-27")
      @invoice_8 = create(:invoice, customer: @customer_1)
      @invoice_9 = create(:invoice, customer: @customer_1)
      @invoice_10 = create(:invoice, customer: @customer_1)

      @transaction_1 = create(:transaction, invoice: @invoice_1, result: "success")
      @transaction_2 = create(:transaction, invoice: @invoice_2, result: "success")
      @transaction_3 = create(:transaction, invoice: @invoice_3, result: "success")
      @transaction_4 = create(:transaction, invoice: @invoice_4, result: "success")
      @transaction_5 = create(:transaction, invoice: @invoice_5, result: "success")
      @transaction_6 = create(:transaction, invoice: @invoice_6, result: "success")
      @transaction_7 = create(:transaction, invoice: @invoice_7, result: "success")
      @transaction_8 = create(:transaction, invoice: @invoice_8, result: "failed")
      @transaction_9 = create(:transaction, invoice: @invoice_9, result: "failed")
      @transaction_10 = create(:transaction, invoice: @invoice_10, result: "failed")

      @invoice_item_1 = create(:invoice_item, item: @item_4, invoice: @invoice_1, quantity: 1, unit_price: 1000)
      @invoice_item_2 = create(:invoice_item, item: @item_4, invoice: @invoice_2, quantity: 2, unit_price: 1500)
      @invoice_item_3 = create(:invoice_item, item: @item_5, invoice: @invoice_3, quantity: 3, unit_price: 2000)
      @invoice_item_4 = create(:invoice_item, item: @item_6, invoice: @invoice_4, quantity: 4, unit_price: 2500)
      @invoice_item_5 = create(:invoice_item, item: @item_7, invoice: @invoice_5, quantity: 5, unit_price: 3000)
      @invoice_item_6 = create(:invoice_item, item: @item_8, invoice: @invoice_6, quantity: 1, unit_price: 3500)
      @invoice_item_7 = create(:invoice_item, item: @item_9, invoice: @invoice_7, quantity: 2, unit_price: 4000)
      @invoice_item_8 = create(:invoice_item, item: @item_7, invoice: @invoice_8, quantity: 3, unit_price: 4500)
      @invoice_item_9 = create(:invoice_item, item: @item_8, invoice: @invoice_9, quantity: 4, unit_price: 5000)
      @invoice_item_10 = create(:invoice_item, item: @item_9, invoice: @invoice_10, quantity: 5, unit_price: 5500)
    end

    describe "User Story 24 - Admin Merchants Index" do
      it 'displays the names of all the merchants' do
        visit admin_merchants_path

        expect(page).to have_content("Barry")
        expect(page).to have_content("Sally")
        expect(page).to have_content("Rayla")
      end
    end

    describe "User Story 25 - Links to Admin Merchant Show Page" do
      it "displays links on each merchants name to admin merchant show page" do
        visit admin_merchants_path

        expect(page).to have_link("Barry")
        expect(page).to have_link("Sally")
        expect(page).to have_link("Rayla")

        click_on "Barry"

        expect(current_path).to eq(admin_merchant_path(@merchant_1))
        expect(current_path).to_not eq(admin_merchant_path(@merchant_2))
        expect(page).to have_content("Barry")
        expect(page).to_not have_content("Sally")

        visit admin_merchants_path
        click_on "Sally"

        expect(current_path).to eq(admin_merchant_path(@merchant_2))
        expect(current_path).to_not eq(admin_merchant_path(@merchant_3))
        expect(page).to have_content("Sally")
        expect(page).to_not have_content("Rayla")
      end
    end

    describe "User Story 27/28 - Admin Merchant enable/disable" do
      it "Displays each merchant in 'Enabled Merchants' group w/a disable button" do
        visit admin_merchants_path

        within "#enabled-merchants" do
          expect(page).to have_button("Disable")
          expect(page).to_not have_button("Enable")
          expect(page).to have_content("Sally")

          click_button "Disable", match: :first
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
          expect(page).to have_button("Enable", count: 7)
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

    describe "User Story 30 - Admin Merchants Top 5 Merchants by Revenue" do
      it "displays top 5 merchants by total revenue generated" do
        visit admin_merchants_path

        within "#top-five-merchants" do
          expect(page).to have_content("Chicken")
          expect(page).to have_content("Potatoes")
          expect(page).to have_content("You Name IT!!!!")
          expect(page).to have_content("Greens")
          expect(page).to have_content("Beans")
          expect(page).to_not have_content("Barry")
          expect(page).to_not have_content("Lamb")
          expect(page).to_not have_content("Sally")
        end
      end

      it "top 5 merchant's names link to their admin merchant show page" do
        visit admin_merchants_path

        within "#merchant-#{@merchant_7.id}" do
          expect(page).to have_link("Chicken")
        end

        within "#merchant-#{@merchant_6.id}" do
          expect(page).to have_link("Potatoes")
        end

        within "#merchant-#{@merchant_9.id}" do
          expect(page).to have_link("You Name IT!!!!")
        end

        within "#merchant-#{@merchant_5.id}" do
          expect(page).to have_link("Greens")
        end

        within "#merchant-#{@merchant_4.id}" do
          expect(page).to have_link("Beans")
        end

        within "#top-five-merchants" do
          expect(page).to_not have_link("Barry")
          expect(page).to_not have_link("Lamb")
          expect(page).to_not have_link("Sally")

          click_on "Chicken"
          expect(current_path).to eq(admin_merchant_path(@merchant_7))
        end
      end

      it "displays total revenue generated next to top 5 merchants' names" do
        visit admin_merchants_path

        within "#top-five-merchants" do
          expect(page).to have_content("Chicken - $150.00 in sales")
          expect(page).to have_content("Potatoes - $100.00 in sales")
          expect(page).to have_content("You Name IT!!!! - $80.00 in sales")
          expect(page).to have_content("Greens - $60.00 in sales")
          expect(page).to have_content("Beans - $40.00 in sales")
        end
      end

      it "lists top 5 merchants from highest to lowest total revenue" do
        visit admin_merchants_path

        within "#top-five-merchants" do
          expect("Chicken").to appear_before("Potatoes")
          expect("Potatoes").to appear_before("You Name IT!!!!")
          expect("You Name IT!!!!").to appear_before("Greens")
          expect("Greens").to appear_before("Beans")
        end
      end
    end

    describe "User Story 31 - Admin Merchants Top Five Merchants Best Day" do
      it "displays top merchants best day and date" do
        visit admin_merchants_path
       
        within "#top-five-merchants" do

          expect(page).to have_content("Top day for Chicken was 1/23/2024")
          expect(page).to have_content("Top day for Potatoes was 5/19/2023")
          expect(page).to have_content("Top day for You Name IT!!!! was 10/27/2184")
          expect(page).to have_content("Top day for Greens was 3/8/2022")
          expect(page).to have_content("Top day for Beans was 11/10/2013")
        end
      end

      it "returns most recent day if multiple days with equal top sales" do
        invoice_11 = create(:invoice, customer: @customer_1, created_at: "2010-10-10")
        invoice_item_11 = create(:invoice_item, item: @item_5, invoice: invoice_11, quantity: 3, unit_price: 2000)

        visit admin_merchants_path

        within "#top-five-merchants" do
          expect(page).to have_content("Top day for Greens was 3/8/2022")
          expect(page).to_not have_content("Top day for Greens was 10/10/2010")
        end
      end
    end
  end
end
