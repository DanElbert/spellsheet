class ChangeSpellBookSpellRelation < ActiveRecord::Migration
  def up
    drop_table :klass_spells_spell_books

    create_table :klass_spells_spell_books do |t|
      t.integer :klass_spell_id
      t.integer :spell_book_id
      t.boolean :is_learned

      t.timestamps
    end
  end

  def down
    drop_table :klass_spells_spell_books

    create_table :klass_spells_spell_books, :id => false do |t|
      t.integer :klass_spell_id
      t.integer :spell_book_id
    end
  end
end
