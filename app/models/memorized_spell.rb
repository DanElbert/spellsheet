class MemorizedSpell < ActiveRecord::Base
  attr_accessible :number_memorized, :spell, :level, :library, :name, :spell_id

  belongs_to :library, inverse_of: :memorized_spells
  belongs_to :spell

  validates :library, presence: true
  validates :level, presence: true
  validates :name, presence: true, if: Proc.new { |ms| ms.spell_id.nil? }

  after_initialize :set_default_values

  def set_default_values
    self.number_memorized ||= 0 if self.has_attribute?(:number_memorized)
  end

  def validate_name_or_spell

  end

  def get_name
    if spell
      name || spell.name
    else
      name
    end
  end

  def get_description
    if spell
      description || spell.short_description
    else
      description
    end
  end

end
