class ChangeDateFormatInInbounds < ActiveRecord::Migration[5.2]
  def change
  end

  def up
  change_column :inbounds, :date, :datetime
 end

 def down
  change_column :inbounds, :date, :date
 end
end
