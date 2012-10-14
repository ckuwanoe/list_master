# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121014193202) do

  create_table "assets", :force => true do |t|
    t.integer  "list_id"
    t.string   "asset_path"
    t.string   "asset_url"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "list_statuses", :force => true do |t|
    t.integer  "list_id"
    t.integer  "organization_id"
    t.string   "status"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.integer  "created_by_user_id"
  end

  create_table "lists", :force => true do |t|
    t.string   "list_name"
    t.integer  "van_list_id"
    t.string   "van_url"
    t.integer  "precinct_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "organizations", :force => true do |t|
    t.string   "organization_name"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "organizations_regions", :force => true do |t|
    t.integer  "organization_id"
    t.integer  "region_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "packets", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "scrapers", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "walked_packets", :force => true do |t|
    t.integer  "packet_id"
    t.integer  "doors_total"
    t.integer  "doors_knocked"
    t.integer  "doors_conversations"
    t.date     "date"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

end
