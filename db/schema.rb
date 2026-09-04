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

ActiveRecord::Schema[8.1].define(version: 2026_09_01_115457) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  # Custom types defined in this database.
  # Note that some types may not work with other database engines. Be careful if changing database.
  create_enum "fight_region_locations", ["Liyue", "Montstadt", "Inazuma", "Sumeru", "Fontaine", "Natlan", "Nod-Krai", "Snezhnaya", "Khaenri'ah"]
  create_enum "regions", ["Liyue", "Fontaine", "Montstadt"]

  create_table "boss_characters", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "fight_exact_location"
    t.enum "fight_region_location", null: false, enum_type: "fight_region_locations"
    t.boolean "is_weekly_boss", default: false
    t.integer "recommended_level"
    t.datetime "updated_at", null: false
  end

  create_table "characters", force: :cascade do |t|
    t.integer "characterable_id"
    t.string "characterable_type"
    t.datetime "created_at", null: false
    t.text "description", null: false
    t.string "name", null: false
    t.integer "rarity", null: false
    t.enum "region", null: false, enum_type: "regions"
    t.datetime "updated_at", null: false
  end

  create_table "playable_characters", force: :cascade do |t|
    t.float "base_attack"
    t.float "base_defense"
    t.float "base_hp"
    t.datetime "created_at", null: false
    t.boolean "is_limited", default: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "current_sign_in_at"
    t.inet "current_sign_in_ip"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.integer "failed_attempts", default: 0, null: false
    t.datetime "last_sign_in_at"
    t.inet "last_sign_in_ip"
    t.datetime "locked_at"
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end
end
