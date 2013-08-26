class DropNumberMemorizedFromKssb < ActiveRecord::Migration
  def change
    remove_column :klass_spells_spell_books, :number_memorized, :integer
  end
end
