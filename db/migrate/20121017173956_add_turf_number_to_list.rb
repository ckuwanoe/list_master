class AddTurfNumberToList < ActiveRecord::Migration
  def change
    add_column :lists, :turf_number, :integer
  end
end
