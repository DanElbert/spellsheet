class Library < ActiveRecord::Base

  belongs_to :klass
  has_many :spell_books
  has_many :memorized_spells, inverse_of: :library, dependent: :destroy

  attr_accessible :klass_id, :name

  before_destroy :check_spell_books

  def number_memorized(spell_id)
    mem = memorized_spells.detect { |m| m.spell_id == spell_id.to_i }
    mem ? mem.number_memorized : 0
  end

  def check_spell_books
    if spell_books.count > 0
      errors.add(:base, 'Delete all spellbooks first')
      false
    else
      true
    end
  end
end
