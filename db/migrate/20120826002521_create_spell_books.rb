class CreateSpellBooks < ActiveRecord::Migration
  def change
    create_table :spell_books do |t|
      t.string :name
      t.integer :klass_id

      t.timestamps
    end
    
    create_table :spell_books_spells, :id => false do |t|
      t.integer :spell_id
      t.integer :spell_book_id
    end
    
  end
end
