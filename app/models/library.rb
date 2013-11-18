class Library < ActiveRecord::Base

  belongs_to :klass
  has_many :spell_books
  has_many :memorized_spells, inverse_of: :library, dependent: :destroy

  attr_accessible :klass_id, :name

  def number_memorized(spell_id)
    mem = memorized_spells.detect { |m| m.spell_id == spell_id.to_i }
    mem ? mem.number_memorized : 0
  end
end
