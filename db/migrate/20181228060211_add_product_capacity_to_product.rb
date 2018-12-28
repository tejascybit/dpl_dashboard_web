class AddProductCapacityToProduct < ActiveRecord::Migration[5.2]
  def change
    change_column :products, :product_num, :string
    add_column :products, :product_capacity, :string 
  end
end
