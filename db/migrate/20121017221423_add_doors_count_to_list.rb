class AddDoorsCountToList < ActiveRecord::Migration
  def change
    add_column :lists, :doors_count, :integer
  end
end
