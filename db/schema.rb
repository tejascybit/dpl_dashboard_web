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

ActiveRecord::Schema.define(version: 2019_01_01_083831) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "access_codes", force: :cascade do |t|
    t.string "access_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "inbound_plans", force: :cascade do |t|
    t.integer "product_id"
    t.integer "logistic_location_id"
    t.string "date"
    t.float "value"
    t.string "material"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "inbounds", force: :cascade do |t|
    t.integer "product_id"
    t.integer "logistic_location_id"
    t.string "date"
    t.float "value"
    t.string "material"
    t.integer "total_tons"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "inventories", force: :cascade do |t|
    t.integer "product_id"
    t.integer "tank_id"
    t.date "date"
    t.float "tank_level"
    t.float "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "logistic_locations", force: :cascade do |t|
    t.string "name"
    t.integer "product_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "production_plans", force: :cascade do |t|
    t.integer "product_id"
    t.date "date"
    t.float "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "productions", force: :cascade do |t|
    t.integer "product_id"
    t.string "parameters"
    t.date "date"
    t.float "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.string "product_type"
    t.string "product_num"
    t.integer "product_capacity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "product_in_production", default: false
    t.string "production_product_type", default: "other"
  end

  create_table "sales_outbounds", force: :cascade do |t|
    t.integer "product_id"
    t.date "date"
    t.string "region"
    t.float "metric_tons"
    t.integer "total_tons"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sales_plans", force: :cascade do |t|
    t.integer "product_id"
    t.string "region"
    t.date "date"
    t.float "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tanks", force: :cascade do |t|
    t.integer "product_id"
    t.string "name"
    t.string "tank_no"
    t.float "tank_capacity"
    t.string "tag_no_mt_value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
