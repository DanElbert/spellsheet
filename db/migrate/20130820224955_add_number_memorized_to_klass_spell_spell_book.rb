class AddNumberMemorizedToKlassSpellSpellBook < ActiveRecord::Migration
  def change
    add_column :klass_spells_spell_books, :number_memorized, :integer
  end
end
