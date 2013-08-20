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

ActiveRecord::Schema.define(:version => 20130820224955) do

  create_table "klass_spells", :force => true do |t|
    t.integer  "klass_id"
    t.integer  "spell_id"
    t.integer  "level"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "klass_spells", ["klass_id"], :name => "index_klass_spells_on_klass_id"
  add_index "klass_spells", ["spell_id"], :name => "index_klass_spells_on_spell_id"

  create_table "klass_spells_spell_books", :force => true do |t|
    t.integer  "klass_spell_id"
    t.integer  "spell_book_id"
    t.boolean  "is_learned"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.integer  "number_memorized"
  end

  create_table "klasses", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "libraries", :force => true do |t|
    t.string   "name"
    t.integer  "klass_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "schools", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "spell_books", :force => true do |t|
    t.string   "name"
    t.integer  "klass_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "library_id"
  end

  create_table "spells", :force => true do |t|
    t.string   "name"
    t.string   "subschool"
    t.string   "descriptor"
    t.string   "casting_time"
    t.string   "components"
    t.boolean  "verbal"
    t.boolean  "somatic"
    t.boolean  "material"
    t.boolean  "focus"
    t.boolean  "divine_focus"
    t.string   "short_description"
    t.boolean  "costly_components"
    t.string   "range"
    t.string   "area"
    t.string   "effect"
    t.string   "targets"
    t.string   "duration"
    t.boolean  "dismissible"
    t.boolean  "shapeable"
    t.string   "saving_throw"
    t.string   "spell_resistence"
    t.text     "description"
    t.string   "source"
    t.integer  "school_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

end
