module CommonTask
  class << self
    def index
      @pro_name = @products.each do |prd|
        final_data[prd.name] = {} if final_data[prd.name].blank?
        @inventories = prd.inventories.where('date BETWEEN ? AND ?', @beginning_of_week, @today).sum(:value)
        final_data[prd.name]['Total'] = (@inventories / MT).round(2)
        prd.tanks.each do |tnk|
          final_data[prd.name][tnk.name] = {} if final_data[prd.name][tnk.name].blank?
          tnk.inventories.each do |inventory|
            final_data[prd.name][tnk.name][:date] = inventory.date
            final_data[prd.name][tnk.name][:tank_level] = inventory.tank_level
            final_data[prd.name][tnk.name][:value] = (inventory.value / MT).round(2)
          end
        end
      end
    end
  end
end
