class ChangeParametersToProductions < ActiveRecord::Migration[5.2]
  def change
    change_column :productions, :parameters, :string
  end
end
