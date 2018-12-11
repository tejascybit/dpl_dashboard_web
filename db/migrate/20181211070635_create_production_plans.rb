class CreateProductionPlans < ActiveRecord::Migration[5.2]
  def change
    create_table :production_plans do |t|
      t.integer  :product_id
      t.date :date
      t.float :value

      t.timestamps
    end
  end
end
