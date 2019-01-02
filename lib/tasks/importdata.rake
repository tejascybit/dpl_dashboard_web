require "#{Rails.root}/app/helpers/application_helper"
include ApplicationHelper

namespace :importdata do
  desc "TODO"
  task get_new_access_code: :environment do

 end

  desc "TODO"
  task check_current_access_code: :environment do
  end

  desc "TODO"
  task get_inventory: :environment do
    start_date = day_range(Date.today).first.strftime('%d-%m-%Y')
    end_date = day_range(Date.today).last.strftime('%d-%m-%Y')
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
    start_date = day_range(Date.yesterday).first.strftime('%d-%m-%Y')
    end_date = day_range(Date.yesterday).last.strftime('%d-%m-%Y')
    Product.where('product_in_production = true').each do |product|
      token = AccessCode.last.get_access_code
      url = 'https://dnlapps.dnlpune.com/DPLPlan/MaintenancePlanning?product=' + product.name.downcase.to_s + '&startDate=' + start_date.to_s + '&endDate=' + end_date.to_s + '&productType=' + product.production_product_type + '&capacity=' + product.product_capacity.to_s + '&accessCode=' + token
      puts url
      response = HTTParty.get(url)
      @data = JSON.parse(response)
      @data['data'].keys.each do |dkey|
        @data['data'][dkey].keys.each do |key|
          next unless key =~ /day/i

          date = @data['data'][dkey][key]['date']
          next unless date.to_s != "N\/A"

          production = Production.where('date =? and parameters=? and product_id =? ', date.to_date, dkey, product.id).first

          if dkey == "prd"
            plans = ProductionPlan.where('date =? and product_id =? ', date.to_date, product.id).first
            if plans.blank?
              plans = ProductionPlan.new
              plans.date = date.to_date
              plans.product_id = product.id
              plans.value = @data['data'][dkey]['planned']
            end
            plans.date = date.to_date
            plans.product_id = product.id
            plans.value = @data['data'][dkey]['planned']
            plans.save
          end
          if production.blank?
            production = Production.new
            production.product_id = product.id
            production.date = date.to_date
          end
          production.date = date.to_date
          production.product_id = product.id
          production.value = @data['data'][dkey][key]['data']
          production.parameters = dkey
          production.save
        end
      end
    end
  end

  desc "TODO"
  task get_sales: :environment do
    require 'json'
    start_date = day_range(Date.yesterday).first.strftime('%d-%m-%Y')
    end_date = day_range(Date.yesterday).last.strftime('%d-%m-%Y')

    get_product_zone.each do |pzone|
          Product.where("product_num != '0'").each do |product|
            token= AccessCode.last.get_access_code
            u ='https://dnlapps.dnlpune.com/DPLPlan/SalesOutbound?product=' + product.product_num.to_s + '&zone='+ pzone + '&startDate=' + start_date.to_s + '&endDate=' + end_date.to_s + '&accessCode=' + token
            response = HTTParty.get(u)
            @data = JSON.parse(response)
            @data['data'].keys.each do |key|
              next unless key =~ /day/i
              date = @data['data'][key]['date']
              if date != 'N/A'
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
     end

  desc "TODO"
  task get_inbound: :environment do
    start_date = day_range(Date.yesterday).first.strftime('%d-%m-%Y')
    end_date = day_range(Date.yesterday).last.strftime('%d-%m-%Y')
    LogisticLocation.all.each do |location|
      token= AccessCode.last.get_access_code
      url = 'https://dnlapps.dnlpune.com/DPLPlan/sourcingInbound?product=' + location.product.name.downcase.to_s + '&location=' + location.name + '&startDate=' + start_date.to_s + '&endDate=' + end_date.to_s + '&accessCode=' + token
      puts url
      response = HTTParty.get(url)
      @data = JSON.parse(response)
      @data['data'].keys.each do |dkey|
        @data['data'][dkey].keys.each do |key|
          next unless key =~ /day/i

          date = @data['data'][dkey][key]['date']
          next unless date.to_s != "N\/A"
          if dkey == "unloadingData"
            inbounds = Inbound.where('date =? and product_id =? and logistic_location_id=? ', date, location.product.id, location.id).first
            if inbounds.blank?
              inbounds = Inbound.new
              inbounds.product_id = location.product.id
              inbounds.date = @data['data'][dkey][key]['date'].to_date
              inbounds.total_tons = @data['data'][dkey][key]['TT']
              inbounds.value = @data['data'][dkey][key]['MT']
              inbounds.logistic_location_id = location.id
              inbounds.material = dkey
            end
            inbounds.product_id = location.product.id
            inbounds.date = @data['data'][dkey][key]['date']
            inbounds.total_tons = @data['data'][dkey][key]['TT']
            inbounds.value = @data['data'][dkey][key]['MT']
            inbounds.logistic_location_id = location.id
            inbounds.material = dkey
            inbounds.save
          end
        end
      end
    end

  end

end
