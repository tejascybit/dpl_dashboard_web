class DashboardController < ApplicationController
  def index
    if(!params[:track_mode].present?)
      params[:track_mode] = "monthly"
    end
    @today = Date.today
    @month_beginning = Date.today.at_beginning_of_month
    @total_stock =(Inventory.where('date BETWEEN ? AND ?',@month_beginning,@today).sum(:value))
    @other = Inventory.select("name").where('date BETWEEN ? AND ?',@month_beginning,@today).sum(:value)


  end
end
