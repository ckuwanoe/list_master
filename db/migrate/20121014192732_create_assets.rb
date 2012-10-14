class CreateAssets < ActiveRecord::Migration
  def change
    create_table :assets do |t|
      t.integer :list_id
      t.string :asset_path
      t.string :asset_url
      t.timestamps
    end
  end
end
