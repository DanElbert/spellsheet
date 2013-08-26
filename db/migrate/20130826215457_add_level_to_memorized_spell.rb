class AddLevelToMemorizedSpell < ActiveRecord::Migration

  class MemorizedSpell < ActiveRecord::Base
  end

  def up
    add_column :memorized_spells, :level, :integer

    MemorizedSpell.reset_column_information

    query = <<-END
      SELECT
        ms.id AS id,
        ks.level AS level
      FROM
        memorized_spells ms
        INNER JOIN libraries l ON l.id = ms.library_id
        INNER JOIN klass_spells ks ON ks.spell_id = ms.spell_id AND ks.klass_id = l.klass_id
    END


    MemorizedSpell.transaction do
      MemorizedSpell.connection.select_all(query).each do |record|
        m = MemorizedSpell.find(record['id'])
        m.level = record['level']
        m.save!
      end
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
