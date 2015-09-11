module ViewModels
  class LibrarySpellList

    attr_reader :spells

    SpellData = Struct.new(:spell, :level, :known, :number_memorized)

    def initialize(library)
      @library = library

      raw_spells = Spell.select('spells.id, spells.name, subschool, descriptor, casting_time, components, verbal, somatic, material, focus, short_description, school_id, is_learned, klass_spells.level, memorized_spells.number_memorized, memorized_spells.id AS memorized_spell_id').
        joins(
          'INNER JOIN klass_spells ON klass_spells.spell_id = spells.id
          INNER JOIN klass_spells_spell_books ON klass_spells_spell_books.klass_spell_id = klass_spells.id
          INNER JOIN spell_books ON spell_books.id = klass_spells_spell_books.spell_book_id
          LEFT OUTER JOIN memorized_spells ON memorized_spells.library_id = spell_books.library_id AND memorized_spells.spell_id = spells.id').
        where("spell_books.library_id = #{@library.id}")

      custom_spells = MemorizedSpell.where(spell_id: nil, library_id: library.id)

      spell_map = {}

      raw_spells.each do |s|
        (spell_map[s.id] ||= []) << s
      end

      @spells = []

      spell_map.each do |_, spells|
        spells.sort! do |a, b|
          if a.is_learned != b.is_learned
            b.is_learned <=> a.is_learned
          elsif a.number_memorized != b.number_memorized
            b.number_memorized <=> a.number_memorized
          else
            a.id <=> b.id
          end
        end
        s = spells.first
        s.number_memorized ||= 0
        s.is_learned = s.is_learned.to_bool
        @spells << s
      end

      ActiveRecord::Associations::Preloader.new.preload(@spells, :school)

      memorized_spells = MemorizedSpell.where(id: @spells.map{ |s| s.memorized_spell_id })

      @spells = @spells.map do |s|
        ViewModels::SpellItem.from_spell(s, memorized_spells.detect { |m| m.id == s.memorized_spell_id})
      end

      @spells += custom_spells.map { |m| ViewModels::SpellItem.from_custom_spell(m) }
    end

    def get_levels
      @spells.map { |s| s.level }.uniq
    end

    def memorized_count_for_level(level)
      count = 0
      @spells.select { |s| s.level == level }.each { |s| count += s.number_memorized }
      count
    end

    def get_spells_by_level(level, memorized = nil)
      @spells.select { |s| s.level == level }.select do |s|
        if memorized.nil?
          true
        elsif memorized
          s.number_memorized > 0
        else
          s.number_memorized == 0
        end
      end.sort { |a, b| a.name <=> b.name }
    end

    def get_json_for_spell_id(spell_id)
      spell = @spells.detect { |s| s.spell_id == spell_id }
      if spell
        return spell.as_json.to_json
      end
    end

    def get_json_for_memorized_spell_id(memorized_spell_id)
      spell = @spells.detect { |s| s.memorized_spell_id == memorized_spell_id }
      if spell
        return spell.as_json.to_json
      end
    end

    def to_json

      json = {library_id: @library.id, spells: []}

      @spells.each do |s|
        s.section = 0
        json[:spells] << s.as_json
      end

      json.to_json
    end
  end
end