class SpellsController < ApplicationController
  def index
    @spells = Spell.order("name")
  end
  
  def show
    @spell = Spell.find(params[:id])
  end

  def new
    @spell = Spell.new
  end

  def create
    @spell = Spell.new(params[:spell])

    params[:klasses].each do |klass_id, level|
      if level.present?
        @spell.klass_spells << KlassSpell.new(klass_id: klass_id, level: level)
      end
    end

    if @spell.save
      redirect_to @spell, notice: 'Spell Saved'
    else
      render action: 'edit'
    end
  end

  def edit
    @spell = Spell.find(params[:id])
  end

  def update
    @spell = Spell.find(params[:id])

    if @spell.update_attributes(params[:spell])

      params[:klasses].each do |klass_id, level|
        if level.present?
          ks = @spell.klass_level_for_klass(klass_id) || KlassSpell.new(klass_id: klass_id)
          ks.level = level
          if ks.new_record?
            @spell.klass_spells << ks
          else
            ks.save
          end
        else
          @spell.remove_klass(klass_id)
        end
      end

      redirect_to @spell, notice: 'Spell Updated'
    else
      render action: 'edit'
    end
  end
  
end
