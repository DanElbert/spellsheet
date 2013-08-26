class MemorizedSpell < ActiveRecord::Base
  attr_accessible :library_id, :number_memorized, :spell_id

  belongs_to :library, inverse_of: :memorized_spells
  belongs_to :spell

  validates :library, presence: true
  validates :spell, presence: true

  after_initialize :set_default_values

  def set_default_values
    self.number_memorized ||= 0 if self.has_attribute?(:number_memorized)
  end
end
