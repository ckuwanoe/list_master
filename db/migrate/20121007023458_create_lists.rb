class CreateLists < ActiveRecord::Migration
  def change
    create_table :lists do |t|
      t.string :list_name
      t.integer :van_list_id
      t.string :van_url
      t.integer :precinct_id
      t.timestamps
    end
  end
end
