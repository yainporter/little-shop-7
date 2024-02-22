require "rails_helper"

RSpec.describe Customer, type: :model do
  describe "validations "do
    it { should validate_presence_of :first_name}
    it { should validate_presence_of :last_name}
  end

  describe "relationships" do
    it {should have_many :invoices}
    it {should have_many(:transactions).through(:invoices)}
  end

  describe "class methods" do 
    describe "self.top_customers" do 
      it "Takes the top 5 costumers with successful transactions" do 
        expect(Customer.top_customers).to eq([])  
      end 
    end 
  end 

  describe "instance methods" do 
  end 
end