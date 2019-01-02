class CreateProductions < ActiveRecord::Migration[5.2]
  def change
    create_table :productions do |t|
      t.integer  :product_id
      t.string   :parameters
      t.date     :date
      t.float    :value

      t.timestamps
    end
  end
end
