class CreateMemorizedSpells < ActiveRecord::Migration
  def change
    create_table :memorized_spells do |t|
      t.integer :library_id
      t.integer :spell_id
      t.integer :number_memorized

      t.timestamps
    end
  end
end
