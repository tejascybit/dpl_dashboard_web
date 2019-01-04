class AddProductCodeToProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :product_code, :string
  end
end
