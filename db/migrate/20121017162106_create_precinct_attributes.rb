class CreatePrecinctAttributes < ActiveRecord::Migration
  def change
    create_table :precinct_attributes do |t|
      t.integer :precinct_id
      t.integer :total_doors
      t.float :precinct_density
      t.timestamps
    end
  end
end
