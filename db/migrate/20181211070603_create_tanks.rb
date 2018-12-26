class CreateTanks < ActiveRecord::Migration[5.2]
  def change
    create_table :tanks do |t|
      t.integer  :product_id
      t.string :name
      t.string :tank_no
      t.float :tank_capacity
      t.string :tag_no_mt_value

      t.timestamps
    end
  end
end
