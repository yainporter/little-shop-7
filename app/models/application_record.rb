class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  def format_total_revenue
    (self.total_revenue.to_f / 100).to_fs(:currency)
  end
end
