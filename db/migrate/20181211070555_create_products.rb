class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.string :name
      t.string :product_type
      t.string :product_num
      t.integer :product_capacity

      t.timestamps
    end
  end
end
