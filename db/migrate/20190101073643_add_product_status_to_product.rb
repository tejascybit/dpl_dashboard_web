class AddProductStatusToProduct < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :product_in_production, :boolean , default:false
  end
end
