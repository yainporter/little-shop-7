class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  def format_total_revenue
    (self.total_revenue.to_f / 100).to_fs(:currency)
  end

  def format_unit_price
    if self.respond_to?(:total_item_revenue)
      (self.total_item_revenue.to_f / 100).to_fs(:currency)
    else
      (self.unit_price.to_f / 100).to_fs(:currency)
    end
  end
end
