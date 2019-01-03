class ChangeDateFormatInInbounds < ActiveRecord::Migration[5.2]
  def change
    change_column :inbounds, :date, :date
  end
end
