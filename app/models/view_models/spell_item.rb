module ViewModels
  class SpellItem

    attr_accessor :section

    def self.from_spell(spell, memorized_spell)
      new(spell, memorized_spell)
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

    def key
      "#{self.spell_id}||#{self.memorized_spell_id}"
    end

    def spell_id
      @spell.id if @spell
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

    def as_json
      {
        key: self.key,
        section: self.section,
        level: self.level,
        spell_id: self.spell_id,
        memorized_spell_id: self.memorized_spell_id,
        is_learned: self.is_learned,
        number_memorized: self.number_memorized,
        name: self.name,
        short_components: self.short_components,
        formatted_school: self.formatted_school,
        short_description: self.short_description
      }
    end
  end
end