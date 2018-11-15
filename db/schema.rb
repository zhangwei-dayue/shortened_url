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

ActiveRecord::Schema.define(version: 20181115071340) do

  create_table "request_user_agents", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.text "user_agent_content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "shortened_url_id"
    t.string "client_ip"
    t.string "query_string"
    t.index ["shortened_url_id"], name: "index_request_user_agents_on_shortened_url_id"
  end

  create_table "shortened_urls", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.text "original_url"
    t.string "short_url"
    t.text "sanitize_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "qr_code_uid"
    t.integer "request_count"
    t.string "utm_source"
    t.string "utm_medium"
    t.string "utm_term"
    t.string "utm_content"
    t.string "utm_campaign"
  end

  create_table "utm_urls", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.text "original_url"
    t.text "utm_url"
    t.string "source"
    t.string "source_link_type"
    t.string "source_obj_id"
    t.string "utm_source"
    t.string "utm_medium"
    t.string "utm_campaign"
    t.string "utm_content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "view_statistics", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "shortened_url_id"
    t.integer "request_user_agent_id"
    t.integer "count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
