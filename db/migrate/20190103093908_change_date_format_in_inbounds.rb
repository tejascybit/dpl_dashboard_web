class ChangeDateFormatInInbounds < ActiveRecord::Migration[5.2]
  def change
    	remove_column :inbounds, :date
	
  end
end
