class CreateInventories < ActiveRecord::Migration[5.2]
  def change
    create_table :inventories do |t|
      t.integer  :product_id
      t.integer  :tank_id
      t.date     :date
      t.float    :tank_level
      t.float    :value

      t.timestamps
    end
  end
end
