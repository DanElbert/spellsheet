class LibrariesController < ApplicationController
  # GET /libraries
  # GET /libraries.json
  def index
    @libraries = Library.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @libraries }
    end
  end

  # GET /libraries/1
  # GET /libraries/1.json
  def show
    @library = Library.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @library }
    end
  end

  # GET /libraries/new
  # GET /libraries/new.json
  def new
    @library = Library.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @library }
    end
  end

  # GET /libraries/1/edit
  def edit
    @library = Library.find(params[:id])
  end

  # POST /libraries
  # POST /libraries.json
  def create
    @library = Library.new(params[:library])

    respond_to do |format|
      if @library.save
        format.html { redirect_to @library, notice: 'Library was successfully created.' }
        format.json { render json: @library, status: :created, location: @library }
      else
        format.html { render action: "new" }
        format.json { render json: @library.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /libraries/1
  # PUT /libraries/1.json
  def update
    @library = Library.find(params[:id])

    respond_to do |format|
      if @library.update_attributes(params[:library])
        format.html { redirect_to @library, notice: 'Library was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @library.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /libraries/1
  # DELETE /libraries/1.json
  def destroy
    @library = Library.find(params[:id])
    @library.destroy

    respond_to do |format|
      format.html { redirect_to libraries_url }
      format.json { head :no_content }
    end
  end

  def spell_sheet
    @mode = params[:mode] || 'memorizing'
    @library = get_library(params[:id])
    @spells = ViewModels::LibrarySpellList.new(@library)

    respond_to do |format|
      format.html do
        @initial_json_data = @spells.to_json(@mode)
        render layout: 'minimal'
      end
      format.pdf {}
    end

  end

  def cast_spell
    @mode = params[:mode]
    @memorized_spell = MemorizedSpell.find(params[:memorized_spell_id])

    @memorized_spell.number_memorized -= 1

    if @memorized_spell.number_memorized <= 0
      @memorized_spell.destroy
    else
      @memorized_spell.save!
    end

    @library = Library.find(params[:id])
    @spells = ViewModels::LibrarySpellList.new(@library)
  end

  def memorize_spell
    @mode = params[:mode]
    @library = Library.find(params[:id])

    if params[:memorized_spell_id].present?
      @memorized_spell = MemorizedSpell.find(params[:memorized_spell_id])
    else
      spell = Spell.find(params[:spell_id])
      level = spell.level_for_klass(@library.klass)
      @memorized_spell = MemorizedSpell.new(spell: spell, level: level, number_memorized: 0, library: @library)
    end

    @memorized_spell.number_memorized += 1
    @memorized_spell.save!

    @spells = ViewModels::LibrarySpellList.new(@library)
  end

  private

  def get_library(lib_id)
    Library.includes(:memorized_spells, {:spell_books => {:klass_spell_spell_books => {:klass_spell => {:spell => :school}}}}).find(lib_id)
  end

end
