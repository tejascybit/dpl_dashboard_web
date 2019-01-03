class ChangeDateToInboundPlan < ActiveRecord::Migration[5.2]
  def change
    remove_column :inbound_plans, :date
  end
end
