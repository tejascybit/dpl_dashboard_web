class Api::V1::DataGetterController < ApplicationController
	include ApplicationHelper
	protect_from_forgery with: :null_session
	before_action :get_date, only: [:inventory_tank, :homedata, :inventory, :production, :sales, :index, :get_stock_data_product_wise ]
	before_action :get_today, only: [:inventory_tank, :homedata, :inventory, :production, :sales, :index, :get_stock_data_product_wise ]

	def index
		@response = HTTParty.get("http://172.16.16.96:8081/DPLPlan/OpeningInventory?tankNumber=10-T-5101A&startDate=01-12-2018&endDate=07-12-2018&accessCode=CYBITTEST").parsed_response
		respond_to do |format|
			format.json { render :json => JSON.parse(@result, :include => { :data => { :only => [:name]}}) }
			format.html { render "index.html.erb" }
		end
	end
	def homedata
		@aday = day_range(@yesterday)
		if(params[:track_mode] == 'monthly')
			@aday = [@yesterday.at_beginning_of_month,@yesterday] 
		end

		inventory_phenol= Inventory.where(date: @today,product:Product.where(name:['Phenol','Hydrated Phenol'])).sum(:value).round(2)
		inventory_benzene= Inventory.where(date: @today,product:Product.where(name:'Benzene')).sum(:value).round(2)
		inventory_acetone= Inventory.where(date: @today,product:Product.where(name:'Acetone')).sum(:value).round(2)
		inventory_propylene= Inventory.where(date: @today,product:Product.where(name:'Propylene')).sum(:value).round(2)
		inventory_ams= Inventory.where(date: @today,product:Product.where(name:'AMS')).sum(:value).round(2)
		inventory_cumene= Inventory.where(date: @today,product:Product.where(name:'Cumene')).sum(:value).round(2)
	  sales_phenol = 	SalesOutbound.where(date: @aday.first..@aday.last,product:Product.where(name:['Phenol','Hydrated Phenol'])).sum(:metric_tons).round(2)
		sales_acetone = 	SalesOutbound.where(date: @aday.first..@aday.last,product:Product.where(name:'Acetone')).sum(:metric_tons).round(2)

		production_phenol =  Production.where(date: @aday.first..@aday.last,parameters: 'prd',product:Product.where(name:'Phenol')).sum(:value).round(2)
		production_phenol_plan = ProductionPlan.where(date: @aday.first..@aday.last,product:Product.where(name:'Phenol')).sum(:value).round(2)
		if production_phenol_plan == 0
			production_per = 100
		else
			production_per = ((production_phenol) * 100/(production_phenol_plan)).round(1)
		end
		inbound_coal_mt = Inbound.where(date: @yesterday,product:Product.where(name:'Coal'),logistic_location:LogisticLocation.where(name:'unloading')).sum(:value).round(2)
		inbound_cumene_mt = Inbound.where(date: @yesterday,product:Product.where(name:'Cumene'),logistic_location:LogisticLocation.where(name:'unloading')).sum(:value).round(2)
		inbound_benzene_mt = Inbound.where(date: @yesterday,product:Product.where(name:'Benzene'),logistic_location:LogisticLocation.where(name:'unloading')).sum(:value).round(2)
		inbound_propylene_mt = Inbound.where(date: @yesterday,product:Product.where(name:'Propylene'),logistic_location:LogisticLocation.where(name:'unloading')).sum(:value).round(2)

		inbound_coal_tt = Inbound.where(date: @yesterday,product:Product.where(name:'Coal'),logistic_location:LogisticLocation.where(name:'unloading')).sum(:total_tons).round(2)
		inbound_cumene_tt = Inbound.where(date: @yesterday,product:Product.where(name:'Cumene'),logistic_location:LogisticLocation.where(name:'unloading')).sum(:total_tons).round(2)
		inbound_benzene_tt = Inbound.where(date: @yesterday,product:Product.where(name:'Benzene'),logistic_location:LogisticLocation.where(name:'unloading')).sum(:total_tons).round(2)
		inbound_propylene_tt = Inbound.where(date: @yesterday,product:Product.where(name:'Propylene'),logistic_location:LogisticLocation.where(name:'unloading')).sum(:total_tons).round(2)

		production_from = @aday.first.to_s(:long)
    production_to	= @aday.last.to_s(:long)

		render json:{data: {'inventory_date': @today.to_s(:long) ,'inventory_phenol': inventory_phenol, 'inventory_benzene': inventory_benzene, 'inventory_acetone': inventory_acetone, 'inventory_propylene': inventory_propylene, 'inventory_cumene': inventory_cumene, 'inventory_ams': inventory_ams, 'sales_phenol': sales_phenol, 'sales_acetone': sales_acetone, 'production_last_update': @yesterday, 'sales_last_update': @yesterday, 'production_from': production_from, 'production_to': production_to,  'production_phenol_total': production_phenol, 'production_phenol_plan': production_phenol_plan, 'production_per': production_per, 'production_progress': 'warning', 'inbound_cumene_mt_tt': (inbound_cumene_mt.to_s + " MT [" + inbound_cumene_tt.to_s + " TT]"), 'inbound_coal_mt_tt': (inbound_coal_mt.to_s + " MT [" + inbound_coal_tt.to_s + " TT]"), 'inbound_benzene_mt_tt': (inbound_benzene_mt.to_s + " MT [" + inbound_benzene_tt.to_s + " TT]"), 'inbound_prpylene_mt_tt': (inbound_propylene_mt.to_s + " MT [" + inbound_propylene_tt.to_s + " TT]") }, success: true, message: ""}

	end

	def inventory
		@aday = day_range(@today)
		inventory_phenol= Inventory.where(date: @today,product:Product.where(name:['Phenol','Hydrated Phenol'])).sum(:value).round(2)
		inventory_acetone= Inventory.where(date: @today,product:Product.where(name:'Acetone')).sum(:value).round(2)
		inventory_propylene= Inventory.where(date: @today,product:Product.where(name:'Propylene')).sum(:value).round(2)
		inventory_cumene= Inventory.where(date: @today,product:Product.where(name:'Cumene')).sum(:value).round(2)
		inventory_benzene= Inventory.where(date: @today,product:Product.where(name:'Benzene')).sum(:value).round(2)

		data_val= Inventory.where(date:(@today - 7.days) ... @today,product:Product.where(name:['Phenol','Hydrated Phenol'])).group(:date).order(date: :desc).sum(:value).map{|x|  {'date' => x[0].to_s(:long),'val' => x[1].round(2)}}
		data_ace= Inventory.where(date:(@today - 7.days) ... @today,product:Product.where(name:'Acetone')).group(:date).order(date: :desc).sum(:value).map{|x|  {'date' => x[0].to_s(:long),'val' => x[1].round(2)}}
		data_pro= Inventory.where(date:(@today - 7.days) ... @today,product:Product.where(name:'Propylene')).group(:date).order(date: :desc).sum(:value).map{|x|  {'date' => x[0].to_s(:long),'val' => x[1].round(2)}}
		data_cum= Inventory.where(date:(@today - 7.days) ... @today,product:Product.where(name:'Cumene')).group(:date).order(date: :desc).sum(:value).map{|x|  {'date' => x[0].to_s(:long),'val' => x[1].round(2)}}
		data_ben= Inventory.where(date:(@today - 7.days) ... @today,product:Product.where(name:'Benzene')).group(:date).order(date: :desc).sum(:value).map{|x|  {'date' => x[0].to_s(:long),'val' => x[1].round(2)}}
		
		render json:{data: {'overall':[{'name': 'Phenol',"qty": inventory_phenol ,'day_wise': data_val },{'name': 'Acetone',"qty":inventory_acetone,'day_wise': data_ace},
			{'name':'Propylene',"qty":inventory_propylene,'day_wise': data_pro},{'name': 'Benzene',"qty": inventory_benzene ,'day_wise': data_ben},{'name': 'Cumene',"qty": inventory_cumene ,'day_wise': data_ace}],
			'tankwise':[{'name':'Phenole Rundown tank 1',"qty":251.862,'level':68.32},
				{'name':'Phenole Rundown tank 2',"qty":171.091,'level':46.23},
				{'name':'Hydrated Phenol Rundown tank',"qty":334.986,'level':82.07}]}, success: true,message:""}
	end
	def inventory_tank
		invet_list=[]
		if(params[:name] == 'Phenol')
			prod = Product.where(name:['Phenol','Hydrated Phenol']).order(id: :desc)
		else
			prod = Product.where("name = ?",params[:name])
		end
		prod.each do |p|
			p.tanks.each do |t|
				invet = {}
				tank_total = 	Inventory.where(date: @today,product_id: p.id, tank_id: t.id).sum(:value).round(2)
				tank_level = 	Inventory.where(date: @today,product_id: p.id,tank_id: t.id).average(:tank_level)
				invet['tank_name'] = t.name
				invet['tank_total'] = tank_total
				invet['tank_level'] = tank_level
				invet_list.push(invet)
			end
		end
		render json:{data: invet_list, success: true, message: ''}
end
	def production
		@aday = day_range(@yesterday)
		if(params[:track_mode] == 'monthly')
			@aday = [@yesterday.at_beginning_of_month,@aday.last] 
		end
		phenol_production_prd = Production.where(date: @aday.first..@yesterday, parameters: 'prd', product: Product.where(name:['Phenol','Hydrated Phenol'])).sum(:value).round(2)
		phenol_production_or = Production.where(date: @aday.first..@yesterday, parameters: 'or', product: Product.where(name:['Phenol','Hydrated Phenol'])).average(:value).round(2)
		phenol_production_data = Production.where(date: @aday.first..@yesterday, parameters: 'prd', product: Product.where(name:['Phenol','Hydrated Phenol'])).group(:date).order(date: :desc).sum(:value).map{|x|  {'date' => x[0].to_s(:long),'val' => x[1].round(2)}}


		
		cumene_production_prd = Production.where(date: @aday.first..@yesterday, parameters: 'prd', product: Product.where(name: 'Cumene')).sum(:value).round(2)
		cumene_production_or = Production.where(date: @aday.first..@yesterday, parameters: 'or', product: Product.where(name: 'Cumene')).average(:value).round(2)
		cumene_production_data = Production.where(date: @aday.first..@yesterday, parameters: 'prd', product: Product.where(name:'Cumene')).group(:date).order(date: :desc).sum(:value).map{|x|  {'date' => x[0].to_s(:long),'val' => x[1].round(2)}}

		ams_production_other = Production.where(date: @yesterday, product: Product.where(name: 'AMS', production_product_type: 'other')).sum(:value).round(2)
		ams_production_data = Production.where(date: @aday.first..@yesterday, product: Product.where(name: 'AMS', production_product_type: 'other')).group(:date).order(date: :desc).sum(:value).map{|x|  {'date' => x[0].to_s(:long),'val' => x[1].round(2)}}

		acetone_production_other = Production.where(date: @yesterday, product: Product.where(name: 'Acetone', production_product_type: 'other')).sum(:value).round(2)
		acetone_production_data = Production.where(date: @aday.first..@yesterday, product: Product.where(name: 'Acetone', production_product_type: 'other')).group(:date).order(date: :desc).sum(:value).map{|x|  {'date' => x[0].to_s(:long),'val' => x[1].round(2)}}


		production_from = @aday.first.to_s(:long)
    production_to	= @yesterday.to_s(:long)

		render json: { data: {'production_from': production_from, 'production_to': production_to, 'plant': [{ 'name': 'Phenol', "qty": phenol_production_prd, 'operating_rate': phenol_production_or,'day_wise': phenol_production_data, 'icon': 'ios-arrow-forward'} ,{ 'name': 'Acetone', 'qty': acetone_production_other,'day_wise': acetone_production_data , 'icon': 'ios-arrow-forward'},{ 'name': 'Cumene', "qty": cumene_production_prd, 'operating_rate': cumene_production_or,'day_wise': cumene_production_data , 'icon': 'ios-arrow-forward'}, { 'name': 'AMS', 'qty': ams_production_other,'day_wise': ams_production_data , 'icon': 'ios-arrow-forward'}] }, success: true, message: '' }


	end
	def sales
		@aday = day_range(@yesterday)
		if(params[:track_mode] == 'monthly')
			@aday = [@yesterday.at_beginning_of_month,@aday.last] 
		end
		sales_phenol = 	SalesOutbound.where(date: @aday.first..@aday.last, product:Product.where(name:['Phenol','Hydrated Phenol'])).sum(:metric_tons).round(2)
		sales_acetone = 	SalesOutbound.where(date: @aday.first..@aday.last, product:Product.where(name:'Acetone')).sum(:metric_tons).round(2)
		hydrated_phenol_tt = 	SalesOutbound.where(date: @aday.first..@aday.last, product:Product.where(name:['Hydrated Phenol'])).sum(:metric_tons).round(2)
		phenol_tt = 	SalesOutbound.where(date: @aday.first..@aday.last, product:Product.where(name:['Phenol'])).sum(:metric_tons).round(2)
		production_from = @aday.first.to_s(:long)
    production_to	= @aday.last.to_s(:long)
		render json:{data: {'production_from': production_from, 'production_to': production_to,'zone': [{ 'name': 'Phenol', 'qty': sales_phenol, 'hydrated_tankers': hydrated_phenol_tt, 'molten': phenol_tt},
			                           { 'name': 'Acetone', 'qty': sales_acetone}]}, success: true, message: ""}

	end




	# def get_stock_data_product_wise
  #   if(!params[:track_mode].present?)
  #     params[:track_mode] = "monthly"
  #   end
  #   final_data ={}
  #   if(!params[:date].present?)
  #     @today = Date.today
  #   else
  #     @today = Date.parse(params[:date])
	#
  #   end
  #   @budget = Budget.where("fromdate <= ? AND todate >= ? AND tag = ? ",@today,@today,params[:track_mode]).last
  #   @product_wise_prod = []
	#
	#
  #   pdprod = ProductionDatum.where('production_date BETWEEN ? AND ?',@budget.fromdate,@today)
	#
	#
  #   @budgetted_prod = @budget.budget_data.sum(get_stock_data_product_wise:production_qty).round(2)
  #   @actual_prod =  ProductionDatum.where('production_date BETWEEN ? AND ?',@budget.fromdate,@today).sum(:production_qty).round(2)
	#
	#
  #   final_data['production_abs_mt'] = ProductionDatum.where('production_date BETWEEN ? AND ?',@budget.fromdate,@today).sum(:production_qty).round(2)
  #   final_data['production_target_mt'] =  @budget.budget_data.sum(:production_qty).round(2)
	#
  #   Product.all.each_with_index do |pd,index|
  #       @product_wise_prod.push({product: pd.name,:production_qty_actual => pdprod.where(:product_id => pd.id).sum(:production_qty),:production_qty_planned => @budget.budget_data.where(:product_id => pd.id).sum(:production_qty)})
	#
  #   end
  #   final_data['product_details'] = @product_wise_prod
	#
	#
  #   render(:json => final_data,:status => 200)
  # end

	private
	def get_today
  @today = params[:date].to_date
  @yesterday = if @today == Date.today
                 @today.yesterday
               else
                 @today
               end
  end


	def get_date
		@aday = day_range(params[:date].to_date)
	end

end
