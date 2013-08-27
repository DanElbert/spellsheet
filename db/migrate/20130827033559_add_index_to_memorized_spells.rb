class AddIndexToMemorizedSpells < ActiveRecord::Migration
  def change
    add_index :memorized_spells, [:spell_id, :library_id], name: 'idx_memorized_spells_spell_library'
  end
end
