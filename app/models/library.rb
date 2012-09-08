class Library < ActiveRecord::Base

  belongs_to :klass
  has_many :spell_books

  attr_accessible :klass_id, :name
end
