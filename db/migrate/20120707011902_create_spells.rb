class CreateSpells < ActiveRecord::Migration
  def change
    create_table :spells do |t|
      t.string :name
      t.string :subschool
      t.string :descriptor
      t.string :casting_time
      t.string :components
      t.boolean :verbal
      t.boolean :somatic
      t.boolean :material
      t.boolean :focus
      t.boolean :divine_focus
      t.string :short_description
      t.boolean :costly_components
      t.string :range
      t.string :area
      t.string :effect
      t.string :targets
      t.string :duration
      t.boolean :dismissible
      t.boolean :shapeable
      t.string :saving_throw
      t.string :spell_resistence
      t.text :description
      t.string :source
      t.references :school

      t.timestamps
    end
    
  end
end
