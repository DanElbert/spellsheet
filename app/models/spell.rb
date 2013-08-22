class Spell < ActiveRecord::Base
  include NormalizeBlanks

  attr_accessible :name, :school_id, :subschool, :descriptor, :casting_time, :components, :verbal, :somatic, :material, :focus, :divine_focus, :costly_components, :dismissible, :shapeable, :short_description, :range, :area, :effect, :targets, :duration, :saving_throw, :spell_resistence, :source, :description

  has_many :klass_spells, inverse_of: :spell, dependent: :destroy
  belongs_to :school

  def level_for_klass(klass)
    ks = klass_spells.detect { |klass_spell| klass_spell.klass_id == klass.id }
    ks ? ks.level : nil
  end

  def klass_level_for_klass(klass_id)
    klass_spells.detect { |klass_spell| klass_spell.klass_id == klass_id }
  end

  def remove_klass(klass_id)
    ks = klass_spells.detect { |klass_spell| klass_spell.klass_id == klass_id }
    klass_spells.delete(ks) if ks
  end
  
  def short_components
    types = []
    types << "V" if verbal
    types << "S" if somatic
    types << "M" if material
    types << "F" if focus
    types.join(", ")
  end
  
  def formatted_duration
    return nil unless self.duration
  
    val = self.duration
    if self.dismissible && !self.duration.end_with?("(D)")
      val + " (D)"
    else
      val
    end
  end
  
  def formatted_school
    val = school.name
    if subschool
      val += " (#{subschool})"
    end
    if descriptor
      val += " [#{descriptor}]"
    end
    val
  end
  
  def formatted_area
    return nil unless self.area
  
    val = self.area
    if self.shapeable && !self.area.end_with?("(S)")
      val + " (S)"
    else
      val
    end
  end
  
end
