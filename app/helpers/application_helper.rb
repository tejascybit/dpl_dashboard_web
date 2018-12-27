module ApplicationHelper
  COMMON_YEAR_DAYS_IN_MONTH = [nil, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
  def get_total
    Inventory.where('date BETWEEN ? AND ?', @begining_of_month, @today).sum(:value)
  end

  def get_total_product_wise
    Product.all.map { |p| p.inventories.where('date BETWEEN ? AND ?', @begining_of_month, @today).sum(:value) }
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

  def get_day_1
    date_range = Date.today.at_beginning_of_month.strftime('%A').to_sym.downcase
  end
  def get_current_week_days_range
    @dynamic_date = (Date.today.beginning_of_week(start_day = get_day_1)..Date.today.end_of_week(start_day = get_day_1)).map.each { |day| day.strftime('%d-%m-%Y') }
  end

end
