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

ActiveRecord::Schema.define(version: 2021_08_18_083315) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "emails", force: :cascade do |t|
    t.text "email", null: false
    t.boolean "is_active", default: true
    t.bigint "shop_setting_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["shop_setting_id"], name: "index_emails_on_shop_setting_id"
  end

  create_table "products", force: :cascade do |t|
    t.text "title", null: false
    t.bigint "shopify_product_id", null: false
    t.bigint "shop_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status"
    t.index ["shop_id"], name: "index_products_on_shop_id"
    t.index ["shopify_product_id"], name: "index_products_on_shopify_product_id"
  end

  create_table "reports", force: :cascade do |t|
    t.string "file_name", null: false
    t.bigint "shop_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["shop_id"], name: "index_reports_on_shop_id"
  end

  create_table "shop_settings", force: :cascade do |t|
    t.integer "global_threshold", null: false
    t.integer "alert_frequency", null: false
    t.bigint "shop_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["shop_id"], name: "index_shop_settings_on_shop_id"
  end

  create_table "shops", force: :cascade do |t|
    t.string "shopify_domain", null: false
    t.string "shopify_token", null: false
    t.boolean "sync_complete", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["shopify_domain"], name: "index_shops_on_shopify_domain", unique: true
  end

  create_table "variants", force: :cascade do |t|
    t.string "sku"
    t.integer "quantity", null: false
    t.bigint "shopify_variant_id", null: false
    t.integer "local_threshold"
    t.bigint "product_id"
    t.bigint "shop_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "inventory_management"
    t.index ["product_id"], name: "index_variants_on_product_id"
    t.index ["shop_id"], name: "index_variants_on_shop_id"
    t.index ["shopify_variant_id"], name: "index_variants_on_shopify_variant_id"
    t.index ["sku"], name: "index_variants_on_sku"
  end

  add_foreign_key "emails", "shop_settings", on_delete: :cascade
  add_foreign_key "products", "shops", on_delete: :cascade
  add_foreign_key "reports", "shops", on_delete: :cascade
  add_foreign_key "shop_settings", "shops", on_delete: :cascade
  add_foreign_key "variants", "products", on_delete: :cascade
  add_foreign_key "variants", "shops", on_delete: :cascade
end
