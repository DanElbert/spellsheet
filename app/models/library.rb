class Library < ActiveRecord::Base

  belongs_to :klass
  has_many :spell_books
  has_many :memorized_spells, inverse_of: :library, dependent: :destroy

  attr_accessible :klass_id, :name

  def number_memorized(spell_id)
    mem = memorized_spells.detect { |m| m.spell_id == spell_id.to_i }
    mem ? mem.number_memorized : 0
  end

  def cast_spell(spell_id)
    mem = memorized_spells.detect { |m| m.spell_id == spell_id.to_i }
    if mem
      mem.number_memorized -= 1

      if mem.number_memorized <= 0
        mem.destroy
      else
        mem.save!
      end
    end
  end

  def memorize_spell(spell_id)
    mem = memorized_spells.detect { |m| m.spell_id == spell_id.to_i }

    if mem
      mem.number_memorized += 1
      mem.save!
    else
      memorized_spells << MemorizedSpell.new(spell_id: spell_id, number_memorized: 1)
    end
  end
end
