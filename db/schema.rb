# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_07_22_122021) do

  create_table "abuse_reports", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "abusable_id"
    t.string "abusable_type"
    t.string "reason"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["abusable_id", "abusable_type"], name: "index_abuse_reports_on_abusable_id_and_abusable_type"
    t.index ["user_id"], name: "index_abuse_reports_on_user_id"
  end

  create_table "action_mailbox_inbound_emails", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.integer "status", default: 0, null: false
    t.string "message_id", null: false
    t.string "message_checksum", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["message_id", "message_checksum"], name: "index_action_mailbox_inbound_emails_uniqueness", unique: true
  end

  create_table "active_storage_attachments", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "answers", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.bigint "question_id", null: false
    t.bigint "user_id", null: false
    t.text "content", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "comments_count", default: 0, null: false
    t.integer "net_upvotes", default: 0
    t.integer "abuse_status", default: 0, null: false
    t.index ["abuse_status"], name: "index_answers_on_abuse_status"
    t.index ["question_id"], name: "index_answers_on_question_id"
    t.index ["user_id"], name: "index_answers_on_user_id"
  end

  create_table "comments", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.text "content"
    t.integer "commentable_id"
    t.string "commentable_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "net_upvotes", default: 0
    t.integer "abuse_status", default: 0, null: false
    t.index ["abuse_status"], name: "index_comments_on_abuse_status"
    t.index ["commentable_id", "commentable_type"], name: "index_comments_on_commentable_id_and_commentable_type"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "credit_transactions", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.bigint "user_id"
    t.integer "value"
    t.text "reason"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "transaction_type", default: 1, null: false
    t.bigint "creditable_id"
    t.string "creditable_type"
    t.index ["creditable_id", "creditable_type"], name: "index_credit_transactions_on_creditable_id_and_creditable_type"
    t.index ["transaction_type"], name: "index_credit_transactions_on_transaction_type"
    t.index ["user_id"], name: "index_credit_transactions_on_user_id"
  end

  create_table "notifications", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.text "message"
    t.datetime "read_at"
    t.integer "notifiable_id"
    t.string "notifiable_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["notifiable_id", "notifiable_type"], name: "index_notifications_on_notifiable_id_and_notifiable_type"
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "questions", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "title"
    t.bigint "user_id"
    t.text "content"
    t.integer "status", default: 0, null: false
    t.string "slug"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "answers_count", default: 0, null: false
    t.integer "comments_count", default: 0, null: false
    t.integer "abuse_status", default: 0, null: false
    t.index ["abuse_status"], name: "index_questions_on_abuse_status"
    t.index ["slug"], name: "index_questions_on_slug", unique: true
    t.index ["status"], name: "index_questions_on_status"
    t.index ["title"], name: "index_questions_on_title", unique: true
    t.index ["user_id"], name: "index_questions_on_user_id"
  end

  create_table "questions_topics", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.bigint "topic_id"
    t.bigint "question_id"
    t.index ["question_id"], name: "index_questions_topics_on_question_id"
    t.index ["topic_id"], name: "index_questions_topics_on_topic_id"
  end

  create_table "topics", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_topics_on_name", unique: true
  end

  create_table "topics_users", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.bigint "topic_id"
    t.bigint "user_id"
    t.index ["topic_id"], name: "index_topics_users_on_topic_id"
    t.index ["user_id"], name: "index_topics_users_on_user_id"
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "name"
    t.string "email", null: false
    t.string "password_digest"
    t.boolean "role", default: false, null: false
    t.integer "credits", default: 0, null: false
    t.string "verification_token"
    t.datetime "verification_token_expire"
    t.string "reset_token"
    t.datetime "reset_token_expire"
    t.datetime "verification_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_token"], name: "index_users_on_reset_token", unique: true
    t.index ["verification_token"], name: "index_users_on_verification_token", unique: true
  end

  create_table "votes", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "vote_type", default: 1
    t.integer "votable_id"
    t.string "votable_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_votes_on_user_id"
    t.index ["votable_id", "votable_type"], name: "index_votes_on_votable_id_and_votable_type"
  end

  add_foreign_key "abuse_reports", "users"
  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "answers", "questions"
  add_foreign_key "answers", "users"
  add_foreign_key "comments", "users"
  add_foreign_key "credit_transactions", "users"
  add_foreign_key "notifications", "users"
  add_foreign_key "questions", "users"
  add_foreign_key "votes", "users"
end
