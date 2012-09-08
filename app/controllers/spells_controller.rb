class SpellsController < ApplicationController
  def index
    @spells = Spell.order("name")
  end
  
  def show
    @spell = Spell.find(params[:id])
  end
  
  
end
