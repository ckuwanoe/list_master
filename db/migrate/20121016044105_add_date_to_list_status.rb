class AddDateToListStatus < ActiveRecord::Migration
  def change
    add_column :list_statuses, :date, :date
  end
end
