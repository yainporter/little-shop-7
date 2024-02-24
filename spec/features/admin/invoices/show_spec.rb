require "rails_helper"

RSpec.describe "Admin Invoices Show", type: :feature do
  describe "As a admin" do
    before do
      @customer_1 = Customer.create!(first_name: "Lance" last_name: "B")
      @customer_2 = Customer.create!(first_name: "Jess" last_name: "K")

      @invoice_1 = @customer_1.invoices.create!(status: 1, created_at: "2011-09-13")
      @invoice_2 = create(:invoice, customer: @customer_2, status: 0, created_at: "2019-07-18")
    end

    describe "User Story 33 - Admin Invoice Show page" do
      it "list invoice attributes" do
        visit admin_invoice_path(@invoice_1)
      end

      it "has customers first and last name" do
        visit admin_invoice_path(@invoice_1)
      end
    end
  end
end