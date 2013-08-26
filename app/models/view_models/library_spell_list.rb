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
        @spells << pick_kssb(kssb_list)
      end

    end

    def get_levels
      levels = []
      @spells.each do |kssb|
        levels << kssb.klass_spell.level
      end
      levels.uniq
    end

    def memorized_count_for_level(level)
      count = 0
      @library.memorized_spells.select { |ms| ms.level == level }.each { |ms| count += ms.number_memorized }
      count
    end

    def get_spells_by_level(level, memorized = nil)
      @spells.select { |kssb| kssb.klass_spell.level == level }.select do |kssb|
        if memorized.nil?
          true
        elsif memorized
          @library.number_memorized(kssb.klass_spell.spell_id) > 0
        else
          @library.number_memorized(kssb.klass_spell.spell_id) == 0
        end
      end.sort { |a, b| a.klass_spell.spell.name <=> b.klass_spell.spell.name }
    end

    private

    def pick_kssb(list)
      return list.first if list.length <= 1

      list.sort! { |a, b| a.spell_book.id <=> b.spell_book.id }

      list.detect(list.first) { |kssb| kssb.is_learned? }
    end
  end
end