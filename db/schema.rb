# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_10_18_152700) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "epics", force: :cascade do |t|
    t.string "name", null: false
    t.string "jira_key", null: false
    t.integer "project_type", default: 0, null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["jira_key"], name: "index_epics_on_jira_key", unique: true
  end

  create_table "tasks", force: :cascade do |t|
    t.bigint "epic_id", null: false
    t.string "title", null: false
    t.string "jira_key", null: false
    t.string "jira_url"
    t.string "pull_request_url"
    t.text "description"
    t.integer "stage", default: 0, null: false
    t.integer "priority", default: 1, null: false
    t.integer "story_points"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["epic_id"], name: "index_tasks_on_epic_id"
    t.index ["jira_key"], name: "index_tasks_on_jira_key", unique: true
    t.index ["priority"], name: "index_tasks_on_priority"
    t.index ["stage"], name: "index_tasks_on_stage"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "tasks", "epics"
end
