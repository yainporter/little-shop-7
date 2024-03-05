class Admin::MerchantsController < ApplicationController
  def index
    @merchants = Merchant.all
  end

  def show
    @merchant = Merchant.find(params[:id])
  end

  def new
    @merchant = Merchant.new
  end

  def create
    merchant = Merchant.create(merchant_params)
    redirect_to admin_merchants_path
  end

  def edit
    @merchant = Merchant.find(params[:id])
  end

  def update
    merchant = Merchant.find(params[:id])

    if params[:merchant_status]
      merchant.update(status: params[:merchant_status])
      redirect_to admin_merchants_path
    else
      if merchant.update(merchant_params)
        redirect_to admin_merchant_path(merchant), notice: "#{merchant.name} Successfully Updated!"
      else
        redirect_to edit_admin_merchant_path(merchant)
        flash[:alert] = "Error Name can't be blank"
      end
    end
  end

  private
  def merchant_params
    params.require(:merchant).permit(:name)
  end
end
