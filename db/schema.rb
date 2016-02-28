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

ActiveRecord::Schema.define(version: 20160228061653) do

  create_table "schedules", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "name"
    t.integer  "work_id"
    t.string   "cron"
    t.text     "input_args"
    t.boolean  "active"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "schedules", ["deleted_at"], name: "index_schedules_on_deleted_at"
  add_index "schedules", ["user_id"], name: "index_schedules_on_user_id"

  create_table "tasks", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "work_id"
    t.integer  "schedule_id"
    t.text     "output"
    t.string   "status"
    t.datetime "deleted_at"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "tasks", ["deleted_at"], name: "index_tasks_on_deleted_at"
  add_index "tasks", ["schedule_id"], name: "index_tasks_on_schedule_id"
  add_index "tasks", ["user_id"], name: "index_tasks_on_user_id"
  add_index "tasks", ["work_id"], name: "index_tasks_on_work_id"

  create_table "user_logs", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "action"
    t.binary   "params"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "user_logs", ["user_id"], name: "index_user_logs_on_user_id"

  create_table "users", force: :cascade do |t|
    t.string   "email"
    t.string   "password_hash"
    t.string   "role"
    t.string   "provider"
    t.string   "provider_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["provider", "provider_id"], name: "index_users_on_provider_and_provider_id", unique: true

  create_table "works", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "name"
    t.text     "input_args"
    t.string   "code_lang"
    t.text     "code"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "works", ["deleted_at"], name: "index_works_on_deleted_at"
  add_index "works", ["user_id"], name: "index_works_on_user_id"

end
