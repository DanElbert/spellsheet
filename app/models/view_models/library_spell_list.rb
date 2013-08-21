module ViewModels
  class LibrarySpellList
    def initialize(library)
      @library = library

      kssb_map = {}

      @library.spell_books.each do |sb|
        sb.klass_spell_spell_books.each do |kssb|
          (kssb_map[kssb.klass_spell] ||= []) << kssb
        end
      end

      @spells = []

      # Create list of KlassSpellSpellBook objects.  Any given spell will only
      # appear in the list once, with preference to the spell book of the lowest id
      kssb_map.each do |ks, kssb_list|
        @spells << kssb_list.min { |a, b| a.spell_book.id <=> b.spell_book.id }
      end

    end

    def get_levels
      levels = []
      @spells.each do |kssb|
        levels << kssb.klass_spell.level
      end
      levels.uniq
    end

    def get_spells_by_level(level, memorized = nil)
      @spells.select { |kssb| kssb.klass_spell.level == level }.select do |kssb|
        mem = kssb.number_memorized || 0
        if memorized.nil?
          true
        elsif memorized
          mem > 0
        else
          mem == 0
        end
      end.sort { |a, b| a.klass_spell.spell.name <=> b.klass_spell.spell.name }
    end
  end
end