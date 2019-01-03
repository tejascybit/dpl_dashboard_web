class ChangeDateFormatInInbounds < ActiveRecord::Migration[5.2]
  def change
    	remove_column :inbounds, :date
	add_column :inbounds, :date, :date
  end
end
