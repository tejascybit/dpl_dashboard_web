class Api::V1::DataGetterController < ApplicationController
	protect_from_forgery with: :null_session
	before_action :set_stock, only: [:show, :update, :destroy]
	ONECR=10000000
	def open_stock
		if(!params[:track_mode].present?)
	      params[:track_mode] = "monthly"
	    end
	    if(!params[:date].present?)
	      @today = Date.today
	    else
	      @today = Date.parse(params[:date])

	    end
    final_data = {}
		product_para_name_1 = {}
		product_para_name_2 = {}
		final_data['product']= Tank.first.name

    render(:json => final_data,:status => 200)



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
