class AddProductIdToLogisticLocation < ActiveRecord::Migration[5.2]
  def change
    add_column :logistic_locations, :product_id, :integer
  end
end
