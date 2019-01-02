require 'httparty'
require 'pp'
class WelcomeController < ApplicationController
  before_action :get_products, only: %i[index production_data_product_wise all_inventory getting_inventory_data getting_sales_data sales_data_product_wise]
  before_action :get_params_date, only: %i[index production_data_product_wise getting_api_data all_inventory]
  include ApplicationHelper
  MT = 10_000
  def index
    if !params[:track_mode].present?
      @month = params[:track_mode]
    else
      params[:track_mode] = 'Monthly'
    end

    @beginning_of_week = @today.beginning_of_week
    @end_of_month = Date.today.end_of_week

    final_data = {}
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


  def generate_new_token
    url = 'https://dnlapps.dnlpune.com/DPLPlan/getAccessCode?userid=cybit&password=Cyb!t@P1'
    response = HTTParty.get(url)
    @data = JSON.parse(response)
  end

  def check_token_limit(token)
    url = 'https://dnlapps.dnlpune.com/DPLPlan/isValid?accessCode=' + token
    response = HTTParty.get(url)
  end

def getting_inventory_data
  require 'json'
  token = generate_new_token
  token = token['key']
  check_token_limit(token)
  start_date = day_range(Date.today).first
  start_date = start_date.strftime('%d-%m-%Y')
  end_date = day_range(Date.today).last
  end_date = end_date.strftime('%d-%m-%Y')

  Tank.all.each do |tank|
    check_token_limit(token)
    puts token
    if check_token_limit(token).nil? || !(check_token_limit(token).empty? && (check_token_limit(token) < 100))
      token = generate_new_token
      token = token['key']
      puts token
    end
    url = 'https://dnlapps.dnlpune.com/DPLPlan/OpeningInventory?tankNumber=' + tank.tank_no + '&startDate=' + start_date.to_s + '&endDate=' + end_date.to_s + '&accessCode=' + token
    puts url
    response = HTTParty.get(url)
    @data = JSON.parse(response)

    @data['data'].keys.each do |key|
      next unless key =~ /day/i

      date = @data['data'][key]['date']
      next unless date != 'N/A'

      inventory = Inventory.where('date =? and tank_id =?', date.to_date, tank.id).first
      if inventory.blank?
        inventory = Inventory.new
        inventory.tank_id = tank.id
        inventory.date = date.to_date
      end
      inventory.product_id = tank.product_id
      inventory.tank_level = @data['data']['tankLevel']
      inventory.value = @data['data'][key]['value']
      inventory.save
    end
  end
end

#
# def all_inventory
#   if !params[:track_mode].present?
#     @month = params[:track_mode]
#   else
#     params[:track_mode] = 'Monthly'
#   end
#
#   @beginning_of_week = @today.beginning_of_week
#   @end_of_month = Date.today.end_of_week
#
#   final_data = {}
#   @pro_name = @products.each do |prd|
#     final_data[prd.name] = {} if final_data[prd.name].blank?
#     @inventories = prd.inventories.where('date BETWEEN ? AND ?', @beginning_of_week, @today).sum(:value)
#     final_data[prd.name]['Total'] = (@inventories / MT).round(2)
#     prd.tanks.each do |tnk|
#       final_data[prd.name][tnk.name] = {} if final_data[prd.name][tnk.name].blank?
#       tnk.inventories.each do |inventory|
#         final_data[prd.name][tnk.name][:date] = inventory.date
#         final_data[prd.name][tnk.name][:tank_level] = inventory.tank_level
#         final_data[prd.name][tnk.name][:value] = (inventory.value / MT).round(2)
#       end
#     end
#   end
# end
def getting_sales_data
  require 'json'
  token = generate_new_token
  token = token['key']
  check_token_limit(token)
  start_date = day_range(Date.today).first
  start_date = start_date.strftime('%d-%m-%Y')
  end_date = day_range(Date.today).last
  end_date = end_date.strftime('%d-%m-%Y')
  get_product_zone.each do |pzone|
    Product.all.each do |product|
      check_token_limit(token)
      if check_token_limit(token).nil? || !((check_token_limit(token).to_i > 0) && (check_token_limit(token).to_i < 100))
        token = generate_new_token
        token = token['key']
        puts token
      end
      url = 'https://dnlapps.dnlpune.com/DPLPlan/SalesOutbound?product=' + product.product_num.to_s + '&zone=' + pzone + '&startDate=' + start_date.to_s + '&endDate=' + end_date.to_s + '&accessCode=' + token
      puts url
      response = HTTParty.get(url)
      @data = JSON.parse(response)
      @data['data'].keys.each do |key|
        next unless key =~ /day/i

        date = @data['data'][key]['date']
        next unless date.to_s != "N\/A"

        sales = SalesOutbound.where('date =? and product_id =? and region =?', date.to_date, product.id, pzone).first
        if sales.blank?
          sales = SalesOutbound.new
          sales.product_id = product.id
          sales.date = date.to_date
        end
        sales.region = pzone
        sales.date = date.to_date
        sales.product_id = product.id
        sales.metric_tons = @data['data'][key]['MT']
        sales.total_tons = @data['data'][key]['TT']
        sales.save
      end
    end
  end
end


def getting_production_data
  require 'json'
  token = generate_new_token
  token = token['key']
  check_token_limit(token)
  start_date = day_range(Date.yesterday).first
  start_date = start_date.strftime('%d-%m-%Y')
  end_date = day_range(Date.yesterday).last
  end_date = end_date.strftime('%d-%m-%Y')
    Product.where("product_in_production = true").each do |product|
      check_token_limit(token)
      puts check_token_limit(token)
      if check_token_limit(token).nil? || !((check_token_limit(token).to_i > 0) && (check_token_limit(token).to_i < 100))
        token = generate_new_token
        token = token['key']
        puts token
      end
          url = 'https://dnlapps.dnlpune.com/DPLPlan/MaintenancePlanning?product=' + product.name.downcase.to_s + '&startDate=' + start_date.to_s + '&endDate=' + end_date.to_s + '&productType=' + product.production_product_type + '&capacity='+ product.product_capacity.to_s + '&accessCode=' + token
          puts url
          response = HTTParty.get(url)
          @data = JSON.parse(response)
          @data['data'].keys.each do |dkey|
            @data['data'][dkey].keys.each do |key|
              next unless key =~ /day/i

              date = @data['data'][dkey][key]['date']
              next unless date.to_s != "N\/A"

              production = Production.where('date =? and product_id =? ', date.to_date, product.id).first
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
def getting_inbound_data
  require 'json'
  token = generate_new_token
  token = token['key']
  check_token_limit(token)
  start_date = day_range(Date.yesterday).first
  start_date = start_date.strftime('%d-%m-%Y')
  end_date = day_range(Date.yesterday).last
  end_date = end_date.strftime('%d-%m-%Y')
  LogisticLocation.all.each do |location|
    check_token_limit(token)
    puts check_token_limit(token)
    if check_token_limit(token).nil? || !((check_token_limit(token).to_i > 0) && (check_token_limit(token).to_i < 100))
      token = generate_new_token
      token = token['key']
      puts token
    end
    url = 'https://dnlapps.dnlpune.com/DPLPlan/sourcingInbound?product=' + location.product.name.downcase.to_s + '&location=' + location.name + '&startDate=' + start_date.to_s + '&endDate=' + end_date.to_s + '&accessCode=' + token
    response = HTTParty.get(url)
    @data = JSON.parse(response)
    @data['data'].keys.each do |dkey|
      @data['data'][dkey].keys.each do |key|
        next unless key =~ /day/i

        date = @data['data'][dkey][key]['date']
        next unless date.to_s != "N\/A"
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


  def production_data_product_wise
    @beginning_of_week = @today.beginning_of_week
    @end_of_month = Date.today.end_of_week
    final_data = {}
    @prod_name = @products.each do |prd|
      final_data[prd.name] = {} if final_data[prd.name].blank?
      @productions_qty = prd.productions.where('date BETWEEN ? AND ?', @beginning_of_week, @today).sum(:parameters)
    end
  end

  private

  def get_products
    @products = Product.all
  end

  def get_params_date
  @today = if params[:date].present?
             Date.parse(params[:date])
           else
             Date.today
           end
  end

end
