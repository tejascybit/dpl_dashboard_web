class SalesOutbound < ApplicationRecord
  belongs_to :product

  def total_sale
    @total_sale ||= sales_outbounds.includes(:product).reduce(0) do |sum, pro_one|
      sum + (pro_one.count * pro_one.product.value).where('date BETWEEN ? AND ?', @beginning_of_week, @today)
    end
  end
end
