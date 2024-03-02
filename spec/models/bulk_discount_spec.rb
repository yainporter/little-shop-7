require "rails_helper"

RSpec.describe BulkDiscount, type: :model do
  describe "validations "do
    it { should validate_presence_of :name}
    it { should validate_numericality_of(:percentage).is_less_than(0).is_greater_than(-1)}
    it { should validate_numericality_of(:quantity_threshold).only_integer}
  end

  describe "relationships" do
    it {should belong_to :merchant}
  end
end
