class Merchant::BulkDiscountsController < ApplicationController
  before_action :find_merchant, except: [:destroy]

  def index; end

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

  def show
    @bulk_discount = BulkDiscount.find(params[:id])
  end

  def edit
    @bulk_discount = BulkDiscount.find(params[:id])
  end

  def update
    @merchant.bulk_discounts.update(bulk_discount_params)
      redirect_to merchant_bulk_discount_path
  end

  def destroy
    bulk_discount = BulkDiscount.find(params[:id])
    bulk_discount.delete

    redirect_to merchant_bulk_discounts_path
  end

  private

  def bulk_discount_params
    params.require(:bulk_discount).permit(:name, :percentage, :quantity_threshold)
  end

  def find_merchant
    @merchant = Merchant.find(params[:merchant_id])
  end
end
