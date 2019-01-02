class AddProductionProductTypeToProduct < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :production_product_type, :string, default: 'other'
  end
end
