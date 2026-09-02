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

ActiveRecord::Schema[8.1].define(version: 2026_09_02_184035) do
  create_table "bike_components", force: :cascade do |t|
    t.integer "bike_id", null: false
    t.integer "component_id", null: false
    t.datetime "created_at", null: false
    t.integer "current_km", default: 0, null: false
    t.date "installed_on", null: false
    t.datetime "updated_at", null: false
    t.index ["bike_id", "component_id"], name: "index_bike_components_on_bike_id_and_component_id", unique: true
    t.index ["bike_id"], name: "index_bike_components_on_bike_id"
    t.index ["component_id"], name: "index_bike_components_on_component_id"
  end

  create_table "bikes", force: :cascade do |t|
    t.string "brand"
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_bikes_on_user_id"
  end

  create_table "components", force: :cascade do |t|
    t.string "component_type"
    t.datetime "created_at", null: false
    t.integer "expected_lifespan_km"
    t.string "name"
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_components_on_user_id"
  end

  create_table "maintenance_logs", force: :cascade do |t|
    t.integer "bike_id", null: false
    t.integer "component_id"
    t.datetime "created_at", null: false
    t.string "description", null: false
    t.integer "km_at_service", default: 0, null: false
    t.date "service_date", null: false
    t.datetime "updated_at", null: false
    t.index ["bike_id"], name: "index_maintenance_logs_on_bike_id"
    t.index ["component_id"], name: "index_maintenance_logs_on_component_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email"
    t.string "name"
    t.string "password_digest"
    t.datetime "updated_at", null: false
  end

  add_foreign_key "bike_components", "bikes"
  add_foreign_key "bike_components", "components"
  add_foreign_key "bikes", "users"
  add_foreign_key "components", "users"
  add_foreign_key "maintenance_logs", "bikes"
  add_foreign_key "maintenance_logs", "components"
end
