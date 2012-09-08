class CreateLibraries < ActiveRecord::Migration
  def change
    create_table :libraries do |t|
      t.string :name
      t.integer :klass_id

      t.timestamps
    end
    
    change_table :spell_books do |t|
      t.references :library
    end
  end
end
