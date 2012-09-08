class ChangeSpellBookRelation < ActiveRecord::Migration
  def up
    drop_table :spell_books_spells
    
    create_table :klass_spells_spell_books, :id => false do |t|
      t.integer :klass_spell_id
      t.integer :spell_book_id
    end
  end

  def down
  
    drop_table :klass_spells_spell_books
  
    create_table :spell_books_spells, :id => false do |t|
      t.integer :spell_id
      t.integer :spell_book_id
    end
  
  end
end
