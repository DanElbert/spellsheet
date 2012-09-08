class CreateKlassSpells < ActiveRecord::Migration
  def change
    create_table :klass_spells do |t|
      t.references :klass
      t.references :spell
      t.integer :level

      t.timestamps
    end
    add_index :klass_spells, :klass_id
    add_index :klass_spells, :spell_id
  end
end
