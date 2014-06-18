class SpellsController < ApplicationController
  def index

    @klasses = Hash[[['Any', nil]] + Klass.order('name').map { |k| [k.name, k.id] }]

    @levels = Hash[[['----', nil]] + (0..9).to_a.map { |l| [l, l] }]

    @schools = Hash[School.order(:name).map { |s| [s.name, s.id]}]
    @schools = {'Any' => nil}.merge(@schools)
    @schools['Any'] = nil

    @sources = Spell.select('COUNT(spells.id) AS c').group(:source).order('c DESC, source').pluck(:source)
    @sources = @sources.map { |s| [s, s] }
    @sources = [['Any', nil]] + @sources
    @sources = Hash[@sources]

    list
  end

  def list
    klass, level, school, source = nil

    if params[:spell_filter]
      klass = params[:spell_filter][:klass]
      level = params[:spell_filter][:level]
      school = params[:spell_filter][:school]
      source = params[:spell_filter][:source]
    end

    @spells = Spell.order("name").includes(:klass_spells => :klass)

    if klass.present?
      @spells = @spells.joins(:klass_spells).where('klass_id = ?', klass)
      @spells = @spells.where('klass_spells.level = ?', level) if level.present?
    end

    @spells = @spells.where("spells.school_id = ?", school) if school.present?
    @spells = @spells.where("spells.source = ?", source) if source.present?
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
