class Api::V1::DataGetterController < ApplicationController
	include ApplicationHelper
	protect_from_forgery with: :null_session
	before_action :set_stock, only: [:show, :update, :destroy]
	MT=10000

	def homedata
		aday = 1.day.ago
		sales_start = 1.day.ago
		today = 1.day.ago
		if today.day<8
			sales_start = Date.new(today.year,today.month,1)
		elsif today.day%7 == 0
			sales_start = 6.days.ago
		else
			a = []
			(1..today.day).each{|x| if x%7 == 0 then a.push(x) end}
			sales_start = Date.new(today.year,today.month,(a.last+1))
		end

		sales_end = sales_start + 7.days

		inventory_phenol= Inventory.where(date:aday,product:Product.where(name:['Phenol','Hydrated Phenol'])).sum(:value).round(2)
		inventory_benzene= Inventory.where(date:aday,product:Product.where(name:'Benzene')).sum(:value).round(2)
		inventory_acetone= Inventory.where(date:aday,product:Product.where(name:'Acetone')).sum(:value).round(2)
		inventory_propylene= Inventory.where(date:aday,product:Product.where(name:'Propylene')).sum(:value).round(2)
		inventory_cumene= Inventory.where(date:aday,product:Product.where(name:'Cumene')).sum(:value).round(2)
	  sales_phenol = 	SalesOutbound.where(date:sales_start..sales_end,product:Product.where(name:['Phenol','Hydrated Phenol'])).sum(:metric_tons).round(2)
		sales_acetone = 	SalesOutbound.where(date:sales_start..sales_end,product:Product.where(name:'Acetone')).sum(:metric_tons).round(2)

		production_phenol =  Production.where(date:Date.yesterday,parameters: 'prd',product:Product.where(name:'Phenol')).sum(:value).round(2)
		production_cumene =  Production.where(date:Date.yesterday,parameters: 'prd',product:Product.where(name:'Cumene')).sum(:value).round(2)
		production_phenol_plan = ProductionPlan.where(date:Date.yesterday,product:Product.where(name:'Phenol')).sum(:value).round(2)
		production_cumene_plan = ProductionPlan.where(date:Date.yesterday,product:Product.where(name:'Cumene')).sum(:value).round(2)
		production_per = ((production_phenol + production_cumene) * 100/(production_phenol_plan + production_cumene_plan)).round(1)

		inbound_coal_mt = Inbound.where(date: Date.yesterday.strftime('%d-%m-%Y'),product:Product.where(name:'Coal'),logistic_location:LogisticLocation.where(name:'unloading')).sum(:value).round(2)
		inbound_cumene_mt = Inbound.where(date: Date.yesterday,product:Product.where(name:'Cumene'),logistic_location:LogisticLocation.where(name:'unloading')).sum(:value).round(2)
		inbound_benzene_mt = Inbound.where(date: Date.yesterday,product:Product.where(name:'Benzene'),logistic_location:LogisticLocation.where(name:'unloading')).sum(:value).round(2)
		inbound_propylene_mt = Inbound.where(date: Date.yesterday,product:Product.where(name:'Propylene'),logistic_location:LogisticLocation.where(name:'unloading')).sum(:value).round(2)

		inbound_coal_tt = Inbound.where(date: Date.yesterday,product:Product.where(name:'Coal'),logistic_location:LogisticLocation.where(name:'unloading')).sum(:value).round(2)
		inbound_cumene_tt = Inbound.where(date: Date.yesterday,product:Product.where(name:'Cumene'),logistic_location:LogisticLocation.where(name:'unloading')).sum(:value).round(2)
		inbound_benzene_tt = Inbound.where(date: Date.yesterday,product:Product.where(name:'Benzene'),logistic_location:LogisticLocation.where(name:'unloading')).sum(:value).round(2)
		inbound_propylene_tt = Inbound.where(date: Date.yesterday,product:Product.where(name:'Propylene'),logistic_location:LogisticLocation.where(name:'unloading')).sum(:value).round(2)

		render json:{data: {'inventory_phenol': inventory_phenol,'inventory_benzene': inventory_benzene,'inventory_acetone': inventory_acetone,'inventory_propylene':inventory_propylene,
			'inventory_cumene': inventory_cumene,'sales_phenol': sales_phenol,'sales_acetone': sales_acetone,
			'production_last_update': Date.today.to_s(:long),'sales_last_update': Date.today.to_s(:long),
			'production_phenol_total': production_phenol,'production_phenol_plan': production_phenol_plan,'production_cumene_total': production_cumene,
			'production_cumene_plan': production_cumene_plan,'production_per': production_per,'production_progress': 'warning',
			'inbound_cumene_mt_tt': inbound_cumene_mt.to_s + ' MT [' + inbound_cumene_tt.to_s + ' TT]',
			'inbound_coal_mt_tt': inbound_coal_mt.to_s + ' MT [' + inbound_coal_tt.to_s + ' TT]',
			'inbound_benzene_mt_tt': inbound_benzene_mt.to_s + ' MT [' + inbound_benzene_tt.to_s +' TT]',
			'inbound_prpylene_mt_tt': inbound_propylene_mt.to_s + ' MT [' + inbound_propylene_tt.to_s +' TT]'}, success: true,message: ""}

	end
	def inventory
		aday = Date.today
		sales_start = aday
		today = aday
		if today.day<8
			sales_start = Date.new(today.year,today.month,1)
		elsif today.day%7 == 0
			sales_start = aday - 6.days
		else
			a = []
			(1..today.day).each{|x| if x%7 == 0 then a.push(x) end}
			sales_start = Date.new(today.year,today.month,(a.last+1))
		end

		sales_end = sales_start + 6.days

		inventory_phenol= Inventory.where(date:aday,product:Product.where(name:['Phenol','Hydrated Phenol'])).sum(:value).round(2)
		inventory_benzene= Inventory.where(date:Date.today,product:Product.where(name:'Benzene')).sum(:value).round(2)
		inventory_acetone= Inventory.where(date:aday,product:Product.where(name:'Acetone')).sum(:value).round(2)
		inventory_propylene= Inventory.where(date:aday,product:Product.where(name:'Propylene')).sum(:value).round(2)
		inventory_cumene= Inventory.where(date:aday,product:Product.where(name:'Cumene')).sum(:value).round(2)
		render json:{data: {'overall':[{'name':'Phenol',"qty":inventory_phenol},{'name':'Acetone',"qty":inventory_acetone},{'name':'Propylene',"qty":inventory_propylene},{'name':'Cumene',"qty":inventory_cumene}],'tankwise':[{'name':'Phenole Rundown tank 1',"qty":251.862,'level':68.32},{'name':'Phenole Rundown tank 2',"qty":171.091,'level':46.23},{'name':'Hydrated Phenol Rundown tank',"qty":334.986,'level':82.07}]}, success: true,message:""}
	end
	def production
		aday = 1.day.ago
		sales_start = 1.day.ago
		today = 1.day.ago
		if today.day<8
			sales_start = Date.new(today.year,today.month,1)
		elsif today.day%7 == 0
			sales_start = 6.days.ago
		else
			a = []
			(1..today.day).each{|x| if x%7 == 0 then a.push(x) end}
			sales_start = Date.new(today.year,today.month,(a.last+1))
		end

		sales_end = sales_start + 7.days


		render json:{data: {'plant':[{'name':'Phenol',"qty":2588.54,'operating_rate':88.21,'downtime_hours':0.00,'onstream_hours':168.00},{'name':'Cumene',"qty":3296.9282,'operating_rate':0.00,'downtime_hours':0.00,'onstream_hours':0.00}],'other':[{'name':'Acetone',"qty":1557.98},{'name':'Benzene Drag',"qty":3077.73},{'name':'AWS',"qty":140.40}]}, success: true,message:""}

	end
	def sales
		aday = 1.day.ago
		sales_start = aday
		today = aday
		if today.day<8
			sales_start = Date.new(today.year,today.month,1)
		elsif today.day%7 == 0
			sales_start = 6.days.ago
		else
			a = []
			(1..today.day).each{|x| if x%7 == 0 then a.push(x) end}
			sales_start = Date.new(today.year,today.month,(a.last+1))
		end

		sales_end = sales_start + 7.days

		sales_phenol = 	SalesOutbound.where(date:sales_start..sales_end,product:Product.where(name:['Phenol','Hydrated Phenol'])).sum(:metric_tons).round(2)
		sales_acetone = 	SalesOutbound.where(date:sales_start..sales_end,product:Product.where(name:'Acetone')).sum(:metric_tons).round(2)
		render json:{data: {'zone':[{'name':'Phenol','qty':sales_phenol,'north_qty':'497.34','west_qty':'777.14','south_qty':'0.00','east_qty':'196.14','central_qty':'3000.05','export_qty':'0.00'},{'name':'Acetone','qty':sales_acetone,'north_qty':'358.6','west_qty':'974.60','south_qty':'1249.8','east_qty':'00.00','central_qty':'3232.22','export_qty':'00.00'}],'other':[{'name':'Heavies','qty':'0.00'}]}, success: true,message:""}

	end
	def index
    @response = HTTParty.get("http://172.16.16.96:8081/DPLPlan/OpeningInventory?tankNumber=10-T-5101A&startDate=01-12-2018&endDate=07-12-2018&accessCode=CYBITTEST").parsed_response
     respond_to do |format|
      format.json { render :json => JSON.parse(@result, :include => { :data => { :only => [:name]}}) }
      format.html { render "index.html.erb" }
     end
   end


	def open_stock
		if(!params[:track_mode].present?)
	      params[:track_mode] = "monthly"
	    end
	    if(!params[:date].present?)
	      @today = Date.today
	    else
	      @today = Date.parse(params[:date])

	    end
			@begining_of_month = Date.today.at_beginning_of_month
			@end_of_month = Date.today.end_of_month
			@products = Product.all
			final_data = {}

				pro_name = @products.each do |prd|
					final_data[prd.name] = {} if final_data[prd.name].blank?
					@inventories = prd.inventories.where("date BETWEEN ? AND ?",@begining_of_month,@today).sum(:value)
					final_data[prd.name]['Total'] = (@inventories/MT).round(2)
										prd.tanks.each do |tnk|
											final_data[prd.name][tnk.name] = {} if final_data[prd.name][tnk.name].blank?
											tnk.inventories.each do |inventory|

												final_data[prd.name][tnk.name][:date] = inventory.date

												final_data[prd.name][tnk.name][:tank_level] = inventory.tank_level
												final_data[prd.name][tnk.name][:value] = (inventory.value/MT).round(2)
											end
										end
						       end

    	render(:json => final_data, :status => 200)



	end

	def create
	  @stock = InventoryStock.new(stock_params)
		if @stock.save
		  render json: @stock, status: :created, location: api_v1_data_getter_index_url(@stock)
        else
          render json: @stock.errors
	    end
	end

	def get_stock_data_product_wise
    if(!params[:track_mode].present?)
      params[:track_mode] = "monthly"
    end
    final_data ={}
    if(!params[:date].present?)
      @today = Date.today
    else
      @today = Date.parse(params[:date])

    end
    @budget = Budget.where("fromdate <= ? AND todate >= ? AND tag = ? ",@today,@today,params[:track_mode]).last
    @product_wise_prod = []


    pdprod = ProductionDatum.where('production_date BETWEEN ? AND ?',@budget.fromdate,@today)


    @budgetted_prod = @budget.budget_data.sum(:production_qty).round(2)
    @actual_prod =  ProductionDatum.where('production_date BETWEEN ? AND ?',@budget.fromdate,@today).sum(:production_qty).round(2)


    final_data['production_abs_mt'] = ProductionDatum.where('production_date BETWEEN ? AND ?',@budget.fromdate,@today).sum(:production_qty).round(2)
    final_data['production_target_mt'] =  @budget.budget_data.sum(:production_qty).round(2)

    Product.all.each_with_index do |pd,index|
        @product_wise_prod.push({product: pd.name,:production_qty_actual => pdprod.where(:product_id => pd.id).sum(:production_qty),:production_qty_planned => @budget.budget_data.where(:product_id => pd.id).sum(:production_qty)})

    end
    final_data['product_details'] = @product_wise_prod


    render(:json => final_data,:status => 200)
  end

	private

	def set_stock
		 @stock = InventoryStock.find(params[:id])
	end

	def stock_params
		params.require(:inventory_stock).permit(:product_id, :budget_id, :opening_stock, :uuid, :tag)
	end


end
