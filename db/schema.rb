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

ActiveRecord::Schema[8.0].define(version: 2025_11_06_170555) do
  create_table "assignments", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "project_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_assignments_on_project_id"
    t.index ["user_id"], name: "index_assignments_on_user_id"
  end

  create_table "projects", force: :cascade do |t|
    t.string "name"
    t.string "company"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "submissions", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "status", default: 0, null: false
    t.datetime "submitted_at"
    t.datetime "reviewed_at"
    t.integer "reviewed_by_id"
    t.text "rejection_reason"
    t.date "period_start"
    t.date "period_end"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["reviewed_by_id"], name: "index_submissions_on_reviewed_by_id"
    t.index ["status"], name: "index_submissions_on_status"
    t.index ["user_id"], name: "index_submissions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "admin", default: false
  end

  create_table "worklogs", force: :cascade do |t|
    t.float "hours", default: 0.0, null: false
    t.text "note", null: false
    t.date "log_date", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "project_id", null: false
    t.integer "user_id", default: 1, null: false
    t.integer "submission_id"
    t.index ["project_id"], name: "index_worklogs_on_project_id"
    t.index ["submission_id"], name: "index_worklogs_on_submission_id"
    t.index ["user_id"], name: "index_worklogs_on_user_id"
  end

  add_foreign_key "assignments", "projects"
  add_foreign_key "assignments", "users"
  add_foreign_key "submissions", "users"
  add_foreign_key "submissions", "users", column: "reviewed_by_id"
  add_foreign_key "worklogs", "projects"
  add_foreign_key "worklogs", "submissions"
  add_foreign_key "worklogs", "users"
end
