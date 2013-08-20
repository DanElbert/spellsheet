class KlassSpellSpellBook < ActiveRecord::Base
  self.table_name = 'klass_spells_spell_books'
  belongs_to :klass_spell
  belongs_to :spell_book

  attr_accessible :is_learned, :number_memorized
end