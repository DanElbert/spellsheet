class ChangeMemorizedSpells < ActiveRecord::Migration
  def change
    add_column :memorized_spells, :name, :string
    add_column :memorized_spells, :description, :string
  end
end
