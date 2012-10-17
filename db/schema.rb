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

ActiveRecord::Schema.define(:version => 20121017221423) do

  create_table "assets", :force => true do |t|
    t.integer  "list_id"
    t.string   "asset_path"
    t.string   "asset_url"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "districts", :force => true do |t|
    t.integer  "precinct_id"
    t.string   "state_senate"
    t.string   "assembly"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "list_attributes", :force => true do |t|
    t.integer  "list_id"
    t.integer  "doors_count"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "list_statuses", :force => true do |t|
    t.integer  "list_id"
    t.integer  "organization_id"
    t.string   "status"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.integer  "created_by_user_id"
    t.date     "date"
  end

  create_table "lists", :force => true do |t|
    t.string   "list_name"
    t.integer  "van_list_id"
    t.string   "van_url"
    t.integer  "precinct_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "turf_number"
    t.integer  "doors_count"
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

  create_table "organizers", :force => true do |t|
    t.integer   "region_id"
    t.string    "first_name"
    t.string    "last_name"
    t.timestamp "created_at", :limit => 6, :null => false
    t.timestamp "updated_at", :limit => 6, :null => false
  end

  create_table "packets", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "precinct_attributes", :force => true do |t|
    t.integer  "precinct_id"
    t.integer  "total_doors"
    t.float    "precinct_density"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "precincts", :force => true do |t|
    t.integer   "precinct_number"
    t.integer   "team_id"
    t.string    "county"
    t.timestamp "created_at",      :limit => 6, :null => false
    t.timestamp "updated_at",      :limit => 6, :null => false
    t.integer   "van_precinct_id"
    t.string    "state"
  end

  create_table "regions", :force => true do |t|
    t.string    "state"
    t.string    "region_name"
    t.timestamp "created_at",  :limit => 6, :null => false
    t.timestamp "updated_at",  :limit => 6, :null => false
  end

  create_table "scrapers", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "teams", :force => true do |t|
    t.integer   "organizer_id"
    t.string    "team_name"
    t.timestamp "created_at",   :limit => 6, :null => false
    t.timestamp "updated_at",   :limit => 6, :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "role_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "state"
    t.integer  "region_id",              :default => 0
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

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
