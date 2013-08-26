class MigrateMemorizedSpells < ActiveRecord::Migration

  class MemorizedSpell < ActiveRecord::Base
  end

  def up
    MemorizedSpell.reset_column_information

    query = <<-END
      SELECT
        ks.spell_id AS spell_id,
        sb.library_id AS library_id,
        kssb.number_memorized AS number_memorized
      FROM
        klass_spells_spell_books kssb
        INNER JOIN klass_spells ks ON kssb.klass_spell_id = ks.id
        INNER JOIN spell_books sb ON kssb.spell_book_id = sb.id
      WHERE
        kssb.number_memorized > 0
    END


    MemorizedSpell.connection.select_all(query).each do |record|
      MemorizedSpell.new(record, {:without_protection => true}).save!
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
