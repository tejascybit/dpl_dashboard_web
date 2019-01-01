namespace :daily_update_db do
  desc 'Daily updated Inventory!'
  task :daily_inventory do
    puts 'Hello'
  end

  desc 'Daily updated Production!'
  task :daily_production do
    puts 'Hello'
  end

  desc 'Daily updated Inbound!'
  task :daily_inbound do
    puts 'Hello'
  end

  desc 'Daily updated Sales and OutBound!'
  task :daily_sales do
    puts 'Hello'
  end

  # desc 'Import CSV File'
  # task :import_file do
  #  CSV.foreach('/home/linkwok/Sonu/Projects/data.csv', headers: true) do |row|
  #     product = Product.where(name: row[4]).first
  #     if product.blank?
  #       product = Product.new
  #       product.name = row[4]
  #    end
  #     product.product_type = row[3]
  #     product.product_num = row[6]
  #     product.save
  #     tank = Tank.where('tank_no =?', row[0]).first
  #     if tank.blank?
  #       tank = Tank.new
  #       tank.tank_no = row[0]
  #     end
  #     tank.product_id = product.id
  #     tank.tank_capacity = row[5]
  #     tank.name = row[1]
  #     tank.tag_no_mt_value = row[2]
  #     tank.save
  #   end
  # end
end
