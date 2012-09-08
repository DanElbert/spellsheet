class SpellBook < ActiveRecord::Base
  attr_accessible :library_id, :name, :spells
  
  belongs_to :library
  belongs_to :klass
  has_many :klass_spell_spell_books
  has_many :klass_spells, :through => :klass_spell_spell_books

  def calculate_page_use
    self.klass_spells.all.reduce(0) do |total, ks|
      total + [ks.level, 1].max
    end
  end

  def total_pages
    100
  end

  def formatted_pages
    "#{calculate_page_use} / #{total_pages}"
  end
  
end
