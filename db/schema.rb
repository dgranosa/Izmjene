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

ActiveRecord::Schema.define(version: 2019_02_20_125526) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "changes", force: :cascade do |t|
    t.date "date", null: false
    t.string "shift", null: false
    t.string "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "data2"
    t.string "starttime"
    t.string "endtime"
    t.boolean "published", default: false
  end

  create_table "psubscriptions", force: :cascade do |t|
    t.string "name"
    t.string "email", null: false
    t.index ["email"], name: "index_psubscriptions_on_email", unique: true
  end

  create_table "settings", force: :cascade do |t|
    t.string "var", null: false
    t.text "value"
    t.integer "thing_id"
    t.string "thing_type", limit: 30
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["thing_type", "thing_id", "var"], name: "index_settings_on_thing_type_and_thing_id_and_var", unique: true
  end

  create_table "subscriptions", force: :cascade do |t|
    t.string "email", null: false
    t.string "shift"
    t.string "klass"
    t.index ["email"], name: "index_subscriptions_on_email", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "fullname"
    t.string "email"
    t.string "role", default: ""
    t.string "password_digest"
    t.string "token", default: "", null: false
    t.index ["token"], name: "index_users_on_token", unique: true
  end

end
