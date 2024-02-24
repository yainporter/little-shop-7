require "rails_helper"

RSpec.describe "Admin Invoices Show", type: :feature do
  describe "As a admin" do
    before do
      @customer_1 = Customer.create!(first_name: "Lance", last_name: "B")
      @customer_2 = Customer.create!(first_name: "Jess", last_name: "K")

      @invoice_1 = @customer_1.invoices.create!(status: 1, created_at: "2011-09-13")
      @invoice_2 = @customer_2.invoices.create!(status: 2, created_at: "2022-03-08")
    end

    describe "User Story 33 - Admin Invoice Show page" do
      it "list invoice attributes" do
        visit admin_invoice_path(@invoice_1)

        expect(page).to have_content(@invoice_1.id)
        expect(page).to have_content("Completed")
        expect(page).to have_content("Tuesday, September 13, 2011")
        expect(page).to_not have_content(@invoice_2.id)
        expect(page).to_not have_content("Cancelled")
        expect(page).to_not have_content("Tuesday, March 08, 2022")
      end

      it "has customers first and last name" do
        visit admin_invoice_path(@invoice_1)

        expect(page).to have_content("Lance B")
        expect(page).to_not have_content("Jess K")
      end
    end
  end
end