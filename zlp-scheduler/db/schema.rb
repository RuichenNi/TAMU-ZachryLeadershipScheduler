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

ActiveRecord::Schema.define(version: 2022_04_09_233811) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cohorts", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "term_id"
    t.integer "time_slots_id"
    t.integer "chosen_time"
    t.boolean "modi"
    t.integer "flag", default: 0
    t.index ["time_slots_id"], name: "index_cohorts_on_time_slots_id"
  end

  create_table "conflicts", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "cost"
    t.integer "reasonid", default: [], array: true
    t.integer "course_id"
    t.integer "schedule_id"
    t.integer "time_slot_id"
    t.index ["course_id"], name: "index_conflicts_on_course_id"
    t.index ["schedule_id"], name: "index_conflicts_on_schedule_id"
    t.index ["time_slot_id"], name: "index_conflicts_on_time_slot_id"
    t.index ["user_id"], name: "index_conflicts_on_user_id"
  end

  create_table "courses", id: :serial, force: :cascade do |t|
    t.string "full_subject"
    t.string "abbreviated_subject"
    t.string "course_name"
    t.integer "course_number"
    t.integer "section_number"
    t.datetime "meetingtime_start"
    t.datetime "meetingtime_end"
    t.string "meeting_days", array: true
    t.string "instructors", array: true
    t.string "meeting_location"
    t.integer "term_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "subject_id"
    t.index ["instructors"], name: "index_courses_on_instructors", using: :gin
    t.index ["meeting_days"], name: "index_courses_on_meeting_days", using: :gin
    t.index ["subject_id"], name: "index_courses_on_subject_id"
    t.index ["term_id"], name: "index_courses_on_term_id"
  end

  create_table "schedule_to_courses", id: :serial, force: :cascade do |t|
    t.integer "schedule_id"
    t.integer "course_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "mandatory", default: false
    t.string "start_time"
    t.string "end_time"
    t.string "reason"
    t.string "weekday"
    t.index ["course_id"], name: "index_schedule_to_courses_on_course_id"
    t.index ["schedule_id"], name: "index_schedule_to_courses_on_schedule_id"
  end

  create_table "schedules", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_schedules_on_user_id"
  end

  create_table "student_actions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "action"
    t.string "schedule_name"
    t.integer "schedule_id"
    t.integer "user_id"
  end

  create_table "subjects", id: :serial, force: :cascade do |t|
    t.string "subject_code"
    t.string "subject_description"
    t.integer "term_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["term_id"], name: "index_subjects_on_term_id"
  end

  create_table "terms", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "opendate"
    t.datetime "closedate"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "term_code"
    t.boolean "active", default: false
    t.boolean "courses_import_complete", default: false
    t.index ["term_code"], name: "index_terms_on_term_code", unique: true
  end

  create_table "time_slots", id: :serial, force: :cascade do |t|
    t.datetime "time"
    t.integer "cost"
    t.boolean "was_conflict"
    t.integer "cohort_id"
    t.string "day"
    t.integer "conflicts_id"
    t.index ["cohort_id"], name: "index_time_slots_on_cohort_id"
    t.index ["conflicts_id"], name: "index_time_slots_on_conflicts_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.integer "uin"
    t.string "lastname", null: false
    t.string "firstname", null: false
    t.string "email", null: false
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "role"
    t.string "password_reset_token"
    t.datetime "password_reset_sent_at"
    t.datetime "password_expires_after"
    t.integer "cohort_id"
    t.boolean "activate", default: true
    t.boolean "urgent", default: false
  end

  add_foreign_key "courses", "subjects"
  add_foreign_key "courses", "terms"
  add_foreign_key "schedule_to_courses", "courses"
  add_foreign_key "schedule_to_courses", "schedules"
  add_foreign_key "schedules", "users"
  add_foreign_key "subjects", "terms"
end
