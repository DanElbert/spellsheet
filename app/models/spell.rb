class Spell < ActiveRecord::Base
  
  has_many :klass_spells
  belongs_to :school
  
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
