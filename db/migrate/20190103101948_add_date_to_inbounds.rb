class AddDateToInbounds < ActiveRecord::Migration[5.2]
  def change
	add_column :inbounds, :date, :date
	add_column :inbound_plans, :date, :date
  end
end
