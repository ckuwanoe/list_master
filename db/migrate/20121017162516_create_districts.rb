class CreateDistricts < ActiveRecord::Migration
  def change
    create_table :districts do |t|
      t.integer :precinct_id
      t.string :state_senate
      t.string :assembly
      t.timestamps
    end
  end
end
