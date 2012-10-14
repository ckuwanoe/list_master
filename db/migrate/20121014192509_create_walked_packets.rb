class CreateWalkedPackets < ActiveRecord::Migration
  def change
    create_table :walked_packets do |t|
      t.integer :packet_id
      t.integer :doors_total
      t.integer :doors_knocked
      t.integer :doors_conversations
      t.date :date
      t.timestamps
    end
  end
end
