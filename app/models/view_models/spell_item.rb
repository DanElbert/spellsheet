module ViewModels
  class SpellItem
    def self.from_spell(spell)
      new(spell, nil)
    end

    def self.from_custom_spell(memorized_spell)
      new(nil, memorized_spell)
    end

    def initialize(spell, memorized_spell)
      @spell = spell
      @memorized_spell = memorized_spell
    end

    def is_spell
      !@spell.nil?
    end

    def spell
      @spell
    end

    def spell_id
      @spell.id if @spell
    end

    def id
      spell_id
    end

    def level
      @spell ? @spell.level : @memorized_spell.level
    end

    def is_learned
      @spell ? @spell.is_learned : true
    end

    def number_memorized
      @spell ? @spell.number_memorized : @memorized_spell.number_memorized
    end

    def name
      @spell ? @spell.name : @memorized_spell.name
    end

    def short_components
      @spell ? @spell.short_components : ''
    end

    def formatted_school
      @spell ? @spell.formatted_school : ''
    end

    def short_description
      @spell ? @spell.short_description : @memorized_spell.description
    end

    def memorized_spell_id
      @spell ? @spell.memorized_spell_id : @memorized_spell.id
    end
  end
end