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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140922172651) do

  create_table "games", force: true do |t|
    t.integer  "session_id"
    t.string   "player_name"
    t.string   "player_email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "player_board"
    t.string   "opponent_board"
    t.string   "sunk_ships"
    t.boolean  "over"
    t.string   "prize"
  end

end
