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

ActiveRecord::Schema.define(version: 20170630204142) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "attendances", force: :cascade do |t|
    t.integer  "lesson_id"
    t.integer  "child_id"
    t.boolean  "present"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["child_id"], name: "index_attendances_on_child_id", using: :btree
    t.index ["lesson_id"], name: "index_attendances_on_lesson_id", using: :btree
  end

  create_table "children", force: :cascade do |t|
    t.string   "name"
    t.integer  "age"
    t.integer  "grade"
    t.integer  "skill"
    t.integer  "group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "parent_id"
    t.index ["group_id"], name: "index_children_on_group_id", using: :btree
  end

  create_table "groups", force: :cascade do |t|
    t.string   "schedule"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "tutor_id"
    t.integer  "host_id"
    t.index ["host_id"], name: "index_groups_on_host_id", using: :btree
  end

  create_table "lessons", force: :cascade do |t|
    t.integer  "group_id"
    t.string   "notes"
    t.datetime "datetime"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_lessons_on_group_id", using: :btree
  end

  create_table "transactions", force: :cascade do |t|
    t.float    "balance_delta"
    t.integer  "c20_delta"
    t.integer  "c15_delta"
    t.integer  "parent_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "description"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",  null: false
    t.string   "encrypted_password",     default: "",  null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,   null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "name"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.string   "type"
    t.float    "balance",                default: 0.0
    t.integer  "C20",                    default: 0
    t.integer  "C15",                    default: 0
    t.string   "phone"
    t.string   "street_address"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  add_foreign_key "attendances", "children"
  add_foreign_key "attendances", "lessons"
  add_foreign_key "children", "groups"
  add_foreign_key "groups", "users", column: "host_id"
  add_foreign_key "lessons", "groups"
end
