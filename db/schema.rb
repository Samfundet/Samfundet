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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20170130203500) do

  create_table "admissions", :force => true do |t|
    t.string   "title"
    t.datetime "shown_application_deadline"
    t.datetime "user_priority_deadline"
    t.datetime "created_at",                                                                           :null => false
    t.datetime "updated_at",                                                                           :null => false
    t.datetime "shown_from"
    t.datetime "admin_priority_deadline"
    t.datetime "actual_application_deadline"
    t.string   "promo_video",                 :default => "https://www.youtube.com/embed/T8MjwROd0dc"
  end

  create_table "applicants", :force => true do |t|
    t.string   "firstname"
    t.string   "surname"
    t.string   "email"
    t.string   "hashed_password"
    t.string   "phone"
    t.datetime "created_at",                                    :null => false
    t.datetime "updated_at",                                    :null => false
    t.boolean  "interested_other_positions"
    t.boolean  "disabled",                   :default => false
    t.integer  "campus_id"
  end

  create_table "areas", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "page_id"
  end

  create_table "billig_events", :primary_key => "event", :force => true do |t|
    t.integer  "a4_ticket_layout"
    t.integer  "dave_id"
    t.integer  "dave_time_id"
    t.string   "event_location"
    t.string   "event_name"
    t.string   "event_note"
    t.datetime "event_time"
    t.string   "event_type"
    t.integer  "external_id"
    t.integer  "organisation"
    t.integer  "receipt_ticket_layout"
    t.datetime "sale_from"
    t.datetime "sale_to"
    t.integer  "tp_ticket_layout"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
    t.boolean  "hidden"
  end

  create_table "billig_payment_error_price_groups", :id => false, :force => true do |t|
    t.string   "error"
    t.integer  "price_group"
    t.integer  "number_of_tickets"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "billig_payment_errors", :id => false, :force => true do |t|
    t.string   "error"
    t.datetime "failed"
    t.string   "message"
    t.integer  "owner_cardno"
    t.string   "owner_email"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "billig_price_groups", :primary_key => "price_group", :force => true do |t|
    t.boolean  "can_be_put_on_card"
    t.boolean  "membership_needed"
    t.boolean  "netsale"
    t.integer  "price"
    t.string   "price_group_name"
    t.integer  "ticket_group"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "billig_purchases", :primary_key => "purchase", :force => true do |t|
    t.integer "owner_member_id"
    t.string  "owner_email"
  end

  create_table "billig_ticket_cards", :id => false, :force => true do |t|
    t.integer "card",            :limit => 8
    t.integer "owner_member_id"
    t.date    "membership_ends"
  end

  create_table "billig_ticket_groups", :primary_key => "ticket_group", :force => true do |t|
    t.integer  "event"
    t.boolean  "is_theater_ticket_group"
    t.integer  "num"
    t.integer  "num_sold"
    t.string   "ticket_group_name"
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
  end

  create_table "billig_tickets", :primary_key => "ticket", :force => true do |t|
    t.integer  "price_group",     :null => false
    t.integer  "purchase",        :null => false
    t.datetime "used"
    t.datetime "refunded"
    t.boolean  "on_card",         :null => false
    t.text     "refunder"
    t.integer  "point_of_refund"
  end

  create_table "blogs", :force => true do |t|
    t.string   "title_no"
    t.text     "content_no"
    t.integer  "author_id"
    t.boolean  "published"
    t.datetime "publish_at"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.integer  "image_id"
    t.text     "lead_paragraph_no"
    t.string   "title_en"
    t.text     "lead_paragraph_en"
    t.text     "content_en"
  end

  create_table "campus", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
    t.boolean  "active",     :default => true
  end

  create_table "document_categories", :force => true do |t|
    t.string "title_en"
    t.string "title_no"
  end

  create_table "documents", :force => true do |t|
    t.string   "title"
    t.date     "publication_date"
    t.integer  "category_id"
    t.integer  "uploader_id"
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "events", :force => true do |t|
    t.string   "non_billig_title_no"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.datetime "non_billig_start_time"
    t.text     "short_description_no"
    t.text     "long_description_no"
    t.integer  "organizer_id",                           :null => false
    t.integer  "area_id",                                :null => false
    t.datetime "publication_time"
    t.string   "age_limit"
    t.string   "spotify_uri"
    t.string   "event_type"
    t.string   "status"
    t.integer  "billig_event_id"
    t.string   "organizer_type"
    t.string   "facebook_link"
    t.string   "primary_color"
    t.string   "secondary_color"
    t.integer  "image_id"
    t.string   "price_type"
    t.string   "title_en"
    t.text     "short_description_en"
    t.text     "long_description_en"
    t.string   "youtube_link"
    t.string   "spotify_link"
    t.string   "soundcloud_link"
    t.string   "instagram_link"
    t.string   "twitter_link"
    t.string   "lastfm_link"
    t.string   "snapchat_link"
    t.string   "vimeo_link"
    t.string   "general_link"
    t.string   "banner_alignment"
    t.integer  "duration",              :default => 120
    t.string   "youtube_embed"
    t.integer  "feedback_survey_id"
    t.boolean  "has_feedback"
  end

  add_index "events", ["billig_event_id"], :name => "index_events_on_billig_event_id", :unique => true

  create_table "everything_closed_periods", :force => true do |t|
    t.text     "message_no"
    t.datetime "closed_from"
    t.datetime "closed_to"
    t.text     "message_en"
  end

  create_table "external_organizers", :force => true do |t|
    t.string "name"
  end

  create_table "feedback_alternatives", :force => true do |t|
    t.integer  "question_id"
    t.integer  "index"
    t.string   "text"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "feedback_answers", :force => true do |t|
    t.integer  "survey_id"
    t.integer  "question_id"
    t.integer  "event_id"
    t.string   "answer"
    t.string   "token"
    t.datetime "date"
  end

  create_table "feedback_questions", :force => true do |t|
    t.integer  "index"
    t.string   "text"
    t.boolean  "has_text_input"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "feedback_surveys", :force => true do |t|
    t.string   "title"
    t.boolean  "open"
    t.text     "start_message"
    t.text     "end_message"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "feedback_surveys_questions", :force => true do |t|
    t.integer "question_id"
    t.integer "survey_id"
  end

  create_table "front_page_locks", :force => true do |t|
    t.integer  "lockable_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "position"
    t.string   "lockable_type"
  end

  add_index "front_page_locks", ["lockable_id"], :name => "index_front_page_events_on_event_id"
  add_index "front_page_locks", ["position"], :name => "index_front_page_events_on_position"

  create_table "group_types", :force => true do |t|
    t.string   "description",                :null => false
    t.integer  "priority",    :default => 0, :null => false
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  create_table "groups", :force => true do |t|
    t.string   "name"
    t.string   "abbreviation"
    t.string   "website"
    t.integer  "group_type_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.text     "short_description"
    t.text     "long_description"
    t.integer  "page_id"
  end

  create_table "images", :force => true do |t|
    t.string   "title"
    t.integer  "uploader_id"
    t.string   "image_file_file_name"
    t.string   "image_file_content_type"
    t.integer  "image_file_file_size"
    t.datetime "image_file_updated_at"
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
  end

  create_table "images_tags", :id => false, :force => true do |t|
    t.integer "image_id"
    t.integer "tag_id"
  end

  create_table "interviews", :force => true do |t|
    t.datetime "time"
    t.string   "acceptance_status",  :limit => 10
    t.integer  "job_application_id"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
    t.string   "location"
    t.text     "comment"
  end

  create_table "job_applications", :force => true do |t|
    t.text     "motivation"
    t.integer  "priority"
    t.integer  "applicant_id"
    t.integer  "job_id"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.boolean  "withdrawn",    :default => false
  end

  create_table "job_tags", :force => true do |t|
    t.string   "title"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "job_tags_jobs", :id => false, :force => true do |t|
    t.integer "job_id"
    t.integer "job_tag_id"
  end

  create_table "jobs", :force => true do |t|
    t.integer  "group_id"
    t.integer  "admission_id"
    t.string   "title_no"
    t.string   "title_en"
    t.string   "teaser_no"
    t.string   "teaser_en"
    t.text     "description_en"
    t.text     "description_no"
    t.boolean  "is_officer"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.text     "default_motivation_text_no"
    t.text     "default_motivation_text_en"
  end

  create_table "log_entries", :force => true do |t|
    t.string   "log"
    t.integer  "admission_id"
    t.integer  "group_id"
    t.integer  "applicant_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.integer  "member_id"
  end

  create_table "members", :primary_key => "medlem_id", :force => true do |t|
    t.string "fornavn"
    t.string "etternavn"
    t.string "mail"
    t.string "telefon"
    t.string "passord"
  end

  create_table "members_roles", :force => true do |t|
    t.integer "member_id"
    t.integer "role_id"
  end

  create_table "page_revisions", :force => true do |t|
    t.string   "title_no"
    t.string   "title_en"
    t.text     "content_no"
    t.text     "content_en"
    t.string   "content_type", :default => "markdown", :null => false
    t.integer  "page_id",                              :null => false
    t.integer  "version",      :default => 1,          :null => false
    t.integer  "member_id"
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
  end

  add_index "page_revisions", ["page_id", "version"], :name => "index_page_revisions_on_page_id_and_version", :unique => true

  create_table "pages", :force => true do |t|
    t.string   "name_no",    :limit => 60,                    :null => false
    t.integer  "role_id",                                     :null => false
    t.datetime "created_at",                                  :null => false
    t.datetime "updated_at",                                  :null => false
    t.string   "name_en",                                     :null => false
    t.boolean  "hide_menu",                :default => false
  end

  add_index "pages", ["name_en"], :name => "index_documents_on_name_en", :unique => true
  add_index "pages", ["name_no"], :name => "index_documents_on_name", :unique => true

  create_table "password_recoveries", :force => true do |t|
    t.string   "recovery_hash"
    t.integer  "applicant_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "pg_search_documents", :force => true do |t|
    t.text     "content"
    t.integer  "searchable_id"
    t.string   "searchable_type"
    t.datetime "publish_at",      :null => false
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "price_groups", :force => true do |t|
    t.string   "name"
    t.integer  "price"
    t.integer  "event_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.string   "title"
    t.text     "description"
    t.boolean  "show_in_hierarchy", :default => false
    t.integer  "role_id"
    t.integer  "group_id"
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
    t.boolean  "passable",          :default => false
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "standard_hours", :force => true do |t|
    t.boolean  "open"
    t.time     "open_time"
    t.time     "close_time"
    t.integer  "area_id"
    t.string   "day"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "standard_hours", ["area_id"], :name => "index_standard_hours_on_area_id"
  add_index "standard_hours", ["day"], :name => "index_standard_hours_on_day"

  create_table "sulten_reservation_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.text     "description"
  end

  create_table "sulten_reservations", :force => true do |t|
    t.datetime "reservation_from"
    t.integer  "people"
    t.integer  "table_id"
    t.integer  "reservation_type_id"
    t.string   "name"
    t.string   "telephone"
    t.string   "email"
    t.string   "allergies"
    t.string   "internal_comment"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.datetime "reservation_to"
  end

  create_table "sulten_table_reservation_types", :force => true do |t|
    t.integer  "table_id"
    t.integer  "reservation_type_id"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  create_table "sulten_tables", :force => true do |t|
    t.integer  "number"
    t.integer  "capacity"
    t.text     "comment"
    t.boolean  "available"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "tags", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_foreign_key "blogs", "images", name: "blog_articles_image_id_fk"

  add_foreign_key "events", "images", name: "events_image_id_fk"

  add_foreign_key "groups", "group_types", name: "groups_group_type_id_fk"

  add_foreign_key "images_tags", "images", name: "images_tags_image_id_fk"
  add_foreign_key "images_tags", "tags", name: "images_tags_tag_id_fk"

  add_foreign_key "interviews", "job_applications", name: "interviews_job_application_id_fk"

  add_foreign_key "job_applications", "applicants", name: "job_applications_applicant_id_fk"
  add_foreign_key "job_applications", "jobs", name: "job_applications_job_id_fk"

  add_foreign_key "job_tags_jobs", "job_tags", name: "job_tags_jobs_job_tag_id_fk"
  add_foreign_key "job_tags_jobs", "jobs", name: "job_tags_jobs_job_id_fk"

  add_foreign_key "jobs", "admissions", name: "jobs_admission_id_fk"
  add_foreign_key "jobs", "groups", name: "jobs_group_id_fk"

  add_foreign_key "members_roles", "roles", name: "members_roles_role_id_fk"

  add_foreign_key "page_revisions", "pages", name: "page_revisions_page_id_fk"

  add_foreign_key "password_recoveries", "applicants", name: "password_recoveries_applicant_id_fk"

  add_foreign_key "roles", "groups", name: "roles_group_id_fk"
  add_foreign_key "roles", "roles", name: "roles_role_id_fk"

end
