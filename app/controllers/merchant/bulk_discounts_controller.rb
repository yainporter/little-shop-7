class Merchant::BulkDiscountsController < ApplicationController
  before_action :find_merchant, only: [:index, :new, :create]

  def index

  end

  def new
    @bulk_discount = @merchant.bulk_discounts.new
  end

  def create
    bulk_discount = @merchant.bulk_discounts.new(bulk_discount_params)
    if bulk_discount.save
      flash[:notice] = "New Bulk Discount made successfully!"
      redirect_to merchant_bulk_discounts_path
    else
      redirect_to new_merchant_bulk_discount_path
      flash[:error] = "Make sure all fields are filled in"
    end
  end

  private

  def bulk_discount_params
    params.require(:bulk_discount).permit(:name, :percentage, :quantity_threshold)
  end

  def find_merchant
    @merchant = Merchant.find(params[:merchant_id])
  end
end
