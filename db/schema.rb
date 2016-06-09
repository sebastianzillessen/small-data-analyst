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

ActiveRecord::Schema.define(version: 20160609090548) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "analyses", force: :cascade do |t|
    t.boolean  "in_progress",          default: true
    t.integer  "research_question_id"
    t.boolean  "private"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.integer  "dataset_id"
  end

  add_index "analyses", ["dataset_id"], name: "index_analyses_on_dataset_id", using: :btree
  add_index "analyses", ["research_question_id"], name: "index_analyses_on_research_question_id", using: :btree

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
  end

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
  end

  create_table "models", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "models_research_questions", force: :cascade do |t|
    t.integer "model_id"
    t.integer "research_question_id"
  end

  create_table "query_assumption_results", force: :cascade do |t|
    t.boolean  "result"
    t.integer  "dataset_id"
    t.integer  "assumption_id"
    t.integer  "analysis_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "query_assumption_results", ["analysis_id"], name: "index_query_assumption_results_on_analysis_id", using: :btree
  add_index "query_assumption_results", ["assumption_id"], name: "index_query_assumption_results_on_assumption_id", using: :btree
  add_index "query_assumption_results", ["dataset_id"], name: "index_query_assumption_results_on_dataset_id", using: :btree

  create_table "research_questions", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.boolean  "private"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_foreign_key "analyses", "datasets"
  add_foreign_key "analyses", "research_questions"
  add_foreign_key "dataset_test_assumption_results", "assumptions"
  add_foreign_key "dataset_test_assumption_results", "datasets"
  add_foreign_key "query_assumption_results", "analyses"
  add_foreign_key "query_assumption_results", "assumptions"
  add_foreign_key "query_assumption_results", "datasets"
end
