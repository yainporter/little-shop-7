class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  def format_total_revenue
    (self.total_revenue.to_f / 100).to_fs(:currency)
  end

  def format_total_revenue_with_discounts
    (self.total_revenue_with_discounts.to_f / 100).to_fs(:currency)
  end

  def format_unit_price
      (self.unit_price.to_f / 100).to_fs(:currency)
  end
end
