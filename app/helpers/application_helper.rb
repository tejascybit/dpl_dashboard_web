module ApplicationHelper
  def get_total
    Inventory.where('date BETWEEN ? AND ?', @begining_of_month, @today).sum(:value)
  end

  def get_total_product_wise
    Product.all.map { |p| p.inventories.where('date BETWEEN ? AND ?', @begining_of_month, @today).sum(:value) }
  end

  def current_quarter_months(date)
    quarters = [[4, 5, 6], [7, 8, 9], [10, 11, 12], [1, 2, 3]]
    quarters[(date.month - 1) / 3]
  end

  def select_pro
    @pr = ["Acetone", "Cumene", "Propylene"]
  end

  def select_sales_pro
    @pr = ["Acetone","Phenol"]
  end

  def get_products_number
    products = Product.where.not(product_num: nil?)
  end

  def get_product_zone
    zone = ["North","East","West","South","Central","Export"]
  end

  def get_current_week_days
    @dynamic_date = (@today.at_beginning_of_week..@today.at_end_of_week).map.each { |day| day.strftime('%d-%m-%Y') }
  end
  def get_current_month
    @today = Date.today
    start_month_date = (@today.at_beginning_of_month..@today.at_end_of_month).map.each { |day| day.strftime('%d-%m-%Y') }
  end
end
