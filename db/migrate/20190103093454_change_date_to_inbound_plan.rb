class ChangeDateToInboundPlan < ActiveRecord::Migration[5.2]
  def change
    change_column :inbound_plans, :date, :datetime
  end
end
