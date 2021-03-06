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

ActiveRecord::Schema[7.0].define(version: 2022_05_02_202207) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "flashcard_answers", force: :cascade do |t|
    t.integer "flashcard_id"
    t.text "fc_type"
    t.boolean "correct"
    t.integer "thinking_time"
    t.integer "answer_response_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "flashcard_category_id"
  end

  create_table "flashcard_categories", force: :cascade do |t|
    t.string "title"
    t.text "note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "member_id"
  end

  create_table "flashcards", force: :cascade do |t|
    t.bigint "flashcard_category_id"
    t.text "pinyin"
    t.text "hanzi"
    t.text "english"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "member_id"
    t.text "pinyin_transliterated"
    t.index ["flashcard_category_id"], name: "index_flashcards_on_flashcard_category_id"
  end

  create_table "members", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_members_on_email", unique: true
    t.index ["reset_password_token"], name: "index_members_on_reset_password_token", unique: true
  end

end
