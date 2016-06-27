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

ActiveRecord::Schema.define(version: 20160627144403) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "analyses", force: :cascade do |t|
    t.boolean  "in_progress",          default: true
    t.integer  "research_question_id"
    t.boolean  "private"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.integer  "dataset_id"
    t.integer  "user_id"
  end

  add_index "analyses", ["dataset_id"], name: "index_analyses_on_dataset_id", using: :btree
  add_index "analyses", ["research_question_id"], name: "index_analyses_on_research_question_id", using: :btree
  add_index "analyses", ["user_id"], name: "index_analyses_on_user_id", using: :btree

  create_table "analyses_models", force: :cascade do |t|
    t.integer "model_id"
    t.integer "analysis_id"
  end

  create_table "assumption_attacks", force: :cascade do |t|
    t.integer "attacker_id"
    t.integer "attacked_id"
  end

  create_table "assumptions", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.boolean  "critical"
    t.string   "type"
    t.text     "required_dataset_fields"
    t.boolean  "fail_on_missing"
    t.text     "r_code"
    t.text     "question"
    t.boolean  "argument_inverted",       default: false
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.integer  "user_id"
  end

  add_index "assumptions", ["user_id"], name: "index_assumptions_on_user_id", using: :btree

  create_table "assumptions_models", force: :cascade do |t|
    t.integer  "model_id"
    t.integer  "assumption_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "data_migrations", id: false, force: :cascade do |t|
    t.string "version", null: false
  end

  add_index "data_migrations", ["version"], name: "unique_data_migrations", unique: true, using: :btree

  create_table "dataset_test_assumption_results", force: :cascade do |t|
    t.integer  "dataset_id"
    t.integer  "assumption_id"
    t.boolean  "result"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "dataset_test_assumption_results", ["assumption_id"], name: "index_dataset_test_assumption_results_on_assumption_id", using: :btree
  add_index "dataset_test_assumption_results", ["dataset_id"], name: "index_dataset_test_assumption_results_on_dataset_id", using: :btree

  create_table "datasets", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.text     "data"
    t.text     "columns"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "user_id"
  end

  add_index "datasets", ["user_id"], name: "index_datasets_on_user_id", using: :btree

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "models", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "user_id"
  end

  add_index "models", ["user_id"], name: "index_models_on_user_id", using: :btree

  create_table "models_research_questions", force: :cascade do |t|
    t.integer "model_id"
    t.integer "research_question_id"
  end

  create_table "query_assumption_results", force: :cascade do |t|
    t.boolean  "result"
    t.integer  "assumption_id"
    t.integer  "analysis_id"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.boolean  "ignore",        default: false
  end

  add_index "query_assumption_results", ["analysis_id"], name: "index_query_assumption_results_on_analysis_id", using: :btree
  add_index "query_assumption_results", ["assumption_id"], name: "index_query_assumption_results_on_assumption_id", using: :btree

  create_table "research_questions", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.boolean  "private"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "user_id"
  end

  add_index "research_questions", ["user_id"], name: "index_research_questions_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.boolean  "approved",               default: false, null: false
    t.string   "role"
  end

  add_index "users", ["approved"], name: "index_users_on_approved", using: :btree
  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
