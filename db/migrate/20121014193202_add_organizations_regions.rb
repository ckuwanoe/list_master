class AddOrganizationsRegions < ActiveRecord::Migration
  def change
    create_table :organizations_regions do |t|
      t.integer :organization_id
      t.integer :region_id
      t.timestamps
    end
  end
end
