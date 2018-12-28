require 'httparty'
require 'pp'
class WelcomeController < ApplicationController
  before_action :get_products, only: %i[index production_data_product_wise all_inventory]
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
    u = 'https://dnlapps.dnlpune.com/DPLPlan/getAccessCode?userid=cybit&password=Cyb!t@P1'
    url = u
    response = HTTParty.get(url)
    @data = JSON.parse(response)
  end

  def check_token_limit(token)
    u = 'https://dnlapps.dnlpune.com/DPLPlan/isValid?accessCode=' + token
    url = u
    response = HTTParty.get(url)
  end

  def getting_inventory_data
    require 'json'
    token = generate_new_token
    token = token['key']
    check_token_limit(token)
    get_current_week_days_range.each do |date|
      start_date = date
      end_date = Date.today.end_of_week(start_day = get_day_1)
      Tank.all.each do |tank|
        check_token_limit(token)
        puts token
        if check_token_limit(token).nil? || !(check_token_limit(token).empty? && (check_token_limit(token) < 100))
          token = generate_new_token
          token = token['key']
          puts token
        end
        u = 'https://dnlapps.dnlpune.com/DPLPlan/OpeningInventory?tankNumber=' + tank.tank_no + '&startDate=' + start_date.to_s + '&endDate=' + end_date.to_s + '&accessCode=' + token
        url = u
        puts url
        response = HTTParty.get(url)
        @data = JSON.parse(response)

        @data['data'].keys.each do |key|
          next unless key =~ /day/i

          date = @data['data'][key]['date']
          date = date.to_date if date.present?
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

  def all_inventory
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

  def getting_sales_data
    require 'json'
    token = generate_new_token
    token = token['key']
    check_token_limit(token)
    get_current_week_days_range.each do |date|
      start_date = date
      end_date = Date.today.end_of_week(start_day = get_day_1)
      get_product_zone.each do |pzone|
        Product.all.each do |product|
          check_token_limit(token)
          if check_token_limit(token).nil? || !((check_token_limit(token).to_i > 0) && (check_token_limit(token).to_i < 100))
            token = generate_new_token
            token = token['key']
            puts token
          end
          u = 'https://dnlapps.dnlpune.com/DPLPlan/SalesOutbound?product=' + product.product_num.to_s + '&zone=' + pzone + '&startDate=' + start_date.to_s + '&endDate=' + end_date.to_s + '&accessCode=' + token
          url = u
          puts url
          response = HTTParty.get(url)
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
  end

  def getting_production_data
    require 'json'
    token = generate_new_token
    token = token['key']
    check_token_limit(token)
    start_date = '01-12-2018'
    end_date = '07-12-2018'
    product_type = 'Plant'
    product_capacity = 600

    Product.all.each do |product|
      check_token_limit(token)
      puts check_token_limit(token)
      if check_token_limit(token).nil? || !((check_token_limit(token).to_i > 0) && (check_token_limit(token).to_i < 100))
        token = generate_new_token
        token = token['key']
        puts token
      end
      # u = 'https://dnlapps.dnlpune.com/DPLPlan/SalesOutbound?product=' + product.name.downcase.to_s + '&zone=' + zone + '&startDate=' + start_date + '&endDate=' + end_date + '&accessCode=' + token
      u = 'https://dnlapps.dnlpune.com/DPLPlan/MaintenancePlanning?product=' + product.name.downcase.to_s + '&startDate=' + start_date.to_s + '&endDate=' + end_date.to_s + '&productType='+ product.product_type + '&capacity=' + product.product_capacity + '&accessCode=' + token
      url = u
      puts url
      response = HTTParty.get(url)
      @data = JSON.parse(response)
      @data['data'].keys.each do |key|
        next unless key =~ /day/i

        date = @data['data'][key]['prd']['date']
        date = date.to_date
        production = Production.where('date =? and product_id =? ', date, product.id).first
        if production.blank?

          production = Production.new
          production.product_type = @data['productType']
          production.product_id = product.id
          production.date = date
        end
        production.parameters = @data['data']
        production.date = date
        production.product_id = product.id
        production.metric_tons = @data['data'][key]['MT']
        production.total_tons = @data['data'][key]['TT']
        production.save
      end
    end
  end

  def getting_inbound_data; end

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
