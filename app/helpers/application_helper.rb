module ApplicationHelper
  def get_total
    Inventory.where('date BETWEEN ? AND ?', @begining_of_month, @today).sum(:value)
  end

  def get_total_product_wise
    Product.all.map { |p| p.inventories.where('date BETWEEN ? AND ?', @begining_of_month, @today).sum(:value) }
  end

  def select_pro
    @pr = %w[Acetone Cumene Propylene]
  end

  def select_sales_pro
    @pr = %w[Acetone Phenol]
  end

  def get_products_number
    products = Product.where.not(product_num: nil?)
  end

  def get_product_zone
    zone = %w[North East West South Central Export]
  end

  def day_range(aday)
    sales_start = aday
    today = aday
    if today.day < 8
      sales_start = Date.new(today.year, today.month, 1)
    elsif today.day % 7 == 0
      sales_start = (aday - 6.days)
    else
      a = []
      (1..today.day).each { |x| a.push(x) if x % 7 == 0 }
      sales_start = Date.new(today.year, today.month, (a.last + 1))
    end
    sales_end = sales_start + 6.days
    a = [sales_start, sales_end]
  end

  def get_product_type
    @selected_pro_type = %w[Phenol Cumene]
  end

  def get_product_name
    @product_name = ['AMS', 'Phenol', 'Cumene', 'Acetone', 'Heavies', 'PIPB drag', 'Benzene drag', 'Acetone purge', 'Light hydrocarbon purge']
  end
end
