class Admin::MerchantsController < ApplicationController
  def index
    @merchants = Merchant.all
    if params[:merchant_status] == "disabled"
      
    else  

    end
  end

  def show
    @merchant = Merchant.find(params[:id])
  end

  def edit
    @merchant = Merchant.find(params[:id])
  end

  def update
    merchant = Merchant.find(params[:id])
    merchant.update(merchant_params)
    redirect_to admin_merchant_path(merchant), notice: "#{merchant.name} Successfully Updated!"
  end

  private
  def merchant_params
    params.require(:merchant).permit(:name)
  end
end
