namespace :importdata do
  desc "TODO"
  task get_new_access_code: :environment do
   
 end

  desc "TODO"
  task check_current_access_code: :environment do
  end

  desc "TODO"
  task get_inventory: :environment do
    aday = Date.today
    sales_start = aday
    today = aday
    if today.day<8
      sales_start = Date.new(today.year,today.month,1)
    elsif today.day%7 == 0
      sales_start = (aday - 6.days)
    else	
      a = []
      (1..today.day).each{|x| if x%7 == 0 then a.push(x) end}
      sales_start = Date.new(today.year,today.month,(a.last+1))
    end
    sales_end = sales_start + 6.days
    
    
    start_date = sales_start.strftime('%d-%m-%Y')
    end_date = sales_end.strftime('%d-%m-%Y')
    
   Tank.all.each do |tank|
    token= AccessCode.last.get_access_code
    u = 'https://dnlapps.dnlpune.com/DPLPlan/OpeningInventory?tankNumber=' + tank.tank_no + '&startDate=' + start_date + '&endDate=' + end_date + '&accessCode=' + token
    response = HTTParty.get(u)
    @data = JSON.parse(response)
    @data['data'].keys.each do |key|
      next unless key =~ /day/i

      date = @data['data'][key]['date']
      if date != 'N/A'
        date = date.to_date
        inventory = Inventory.where('date =? and tank_id =?', date, tank.id).first
        if inventory.blank?
          inventory = Inventory.new
          inventory.tank_id = tank.id
          inventory.date = date
        end
        inventory.product_id = tank.product_id
        inventory.tank_level = @data['data']['tankLevel']
        inventory.value = @data['data'][key]['value']
        inventory.save
      end
    end
   end
  end

  desc "TODO"
  task get_production: :environment do
    

  end

  desc "TODO"
  task get_sales: :environment do
    require 'json'
    aday = 1.day.ago
    sales_start = aday
    today = aday
    if today.day<8
      sales_start = Date.new(today.year,today.month,1)
    elsif today.day%7 == 0
      sales_start = (aday - 6.days)
    else	
      a = []
      (1..today.day).each{|x| if x%7 == 0 then a.push(x) end}
      sales_start = Date.new(today.year,today.month,(a.last+1))
    end
    sales_end = sales_start + 6.days
    
    
    start_date = sales_start.strftime('%d-%m-%Y')
    end_date = sales_end.strftime('%d-%m-%Y')
    
    ["North","East","West","South","Central","Export"].each do |pzone|
          Product.where("product_num != '0'").each do |product|
            token= AccessCode.last.get_access_code
            u ='https://dnlapps.dnlpune.com/DPLPlan/SalesOutbound?product=' + product.product_num.to_s + '&zone='+ pzone + '&startDate=' + start_date.to_s + '&endDate=' + end_date.to_s + '&accessCode=' + token
            response = HTTParty.get(u)
            @data = JSON.parse(response)
            @data['data'].keys.each do |key|
              next unless key =~ /day/i
              date = @data['data'][key]['date']
              date = date.to_date if date.present?
              sales = SalesOutbound.where('date =? and product_id =? and region =?', date, product.id, pzone).first
              if sales.blank?
                sales = SalesOutbound.new
                sales.product_id = product.id
                sales.date = date
              end
                sales.region = pzone
                sales.date = date
                sales.product_id = product.id
                sales.metric_tons = @data['data'][key]['MT']
                sales.total_tons = @data['data'][key]['TT']
                sales.save
            end
          end
        end
     end

  desc "TODO"
  task get_inbound: :environment do

  end

end
