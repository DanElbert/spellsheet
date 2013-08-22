class KlassSpell < ActiveRecord::Base

  attr_accessible :klass_id, :level

  belongs_to :klass
  belongs_to :spell, inverse_of: :klass_spells

  has_many :klass_spell_spell_books, dependent: :destroy
  has_many :spell_books, :through => :klass_spell_spell_books
  
  validates :klass, :spell, :presence => true
  
end
