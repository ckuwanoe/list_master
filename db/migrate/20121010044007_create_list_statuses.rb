class CreateListStatuses < ActiveRecord::Migration
  def change
    create_table :list_statuses do |t|
      t.integer :list_id
      t.integer :organization_id
      t.string :status
      t.timestamps :datetime
      t.integer :created_by_user_id
      t.timestamps
    end
  end
end
