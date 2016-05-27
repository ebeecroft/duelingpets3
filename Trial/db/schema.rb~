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

ActiveRecord::Schema.define(:version => 20131013235319) do

  create_table "comments", :force => true do |t|
    t.integer  "user_id"
    t.text     "message"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "equips", :force => true do |t|
    t.integer  "petowner_id"
    t.integer  "inventory_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "fights", :force => true do |t|
    t.integer  "petowner_id"
    t.integer  "monster_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "inventories", :force => true do |t|
    t.integer  "user_id"
    t.integer  "item_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "items", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_on"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "maintopics", :force => true do |t|
    t.integer  "user_id"
    t.string   "topicname"
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "narratives", :force => true do |t|
    t.integer  "subtopic_id"
    t.integer  "user_id"
    t.text     "story"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "petowners", :force => true do |t|
    t.integer  "user_id"
    t.integer  "pet_id"
    t.string   "pet_name"
    t.datetime "adopted_on"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "pets", :force => true do |t|
    t.string   "species_name"
    t.text     "description"
    t.datetime "created_on"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "subtopics", :force => true do |t|
    t.integer  "maintopic_id"
    t.integer  "user_id"
    t.string   "topicname"
    t.text     "description"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "vname"
    t.date     "joined_on"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "password_digest"
    t.string   "remember_token"
  end

  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"

end
