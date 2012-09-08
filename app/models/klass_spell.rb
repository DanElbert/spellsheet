class KlassSpell < ActiveRecord::Base
  belongs_to :klass
  belongs_to :spell

  has_many :klass_spell_spell_books
  has_many :spell_books, :through => :klass_spell_spell_books
  
  validates :klass, :spell, :presence => true
  
end
