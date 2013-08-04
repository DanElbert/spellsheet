class SpellBooksController < ApplicationController

  # GET /spell_books/1
  # GET /spell_books/1.json
  def show
    @spell_book = SpellBook.find(params[:id])
    @levels = (0..9).to_a

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @spell_book }
    end
  end

  # POST /spell_books/new
  # POST /spell_books/new.json
  def new
    @spell_book = SpellBook.new
    @spell_book.library_id = params[:library_id]

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @spell_book }
    end
  end

  # GET /spell_books/1/edit
  def edit
    @spell_book = SpellBook.find(params[:id])
  end

  # POST /spell_books
  # POST /spell_books.json
  def create
    @spell_book = SpellBook.new(params[:spell_book])
    @spell_book.klass = @spell_book.library.klass

    respond_to do |format|
      if @spell_book.save
        format.html { redirect_to @spell_book.library, notice: 'Spell book was successfully created.' }
        format.json { render json: @spell_book, status: :created, location: @spell_book }
      else
        format.html { render action: "new" }
        format.json { render json: @spell_book.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /spell_books/1
  # PUT /spell_books/1.json
  def update
    @spell_book = SpellBook.find(params[:id])

    respond_to do |format|
      if @spell_book.update_attributes(params[:spell_book])
        format.html { redirect_to @spell_book.library, notice: 'Spell book was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @spell_book.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /spell_books/1
  # DELETE /spell_books/1.json
  def destroy
    @spell_book = SpellBook.find(params[:id])
    library_id = @spell_book.library_id
    @spell_book.destroy

    respond_to do |format|
      format.html { redirect_to library_url(library_id) }
      format.json { head :no_content }
    end
  end
  
  def add_spell
    book = SpellBook.includes(:klass_spells).find(params[:id])
    spell = KlassSpell.find(params[:spell_id])
    unless book.klass_spells.include?(spell)
      book_spell = KlassSpellSpellBook.new()
      book_spell.klass_spell = spell
      book_spell.spell_book = book
      book_spell.is_learned = true
      book_spell.save
    end
    render :nothing => true
  end
  
  def remove_spell
    book = SpellBook.find(params[:id])
    book.klass_spells.delete(KlassSpell.find(params[:spell_id]))
    book.save
    render :nothing => true
  end

  def toggle_learned
    book = SpellBook.find(params[:id])
    klass_spell_spell_book = KlassSpellSpellBook.find(params[:klass_spell_spell_book_id])
    klass_spell_spell_book.is_learned = !klass_spell_spell_book.is_learned
    klass_spell_spell_book.save
    render :nothing => true
  end
  
  def list_spells
    @spell_book = SpellBook.includes(:klass_spells).find(params[:id])
    level = params[:spell_filter][:level]
    @available = KlassSpell.where(:klass_id => @spell_book.klass, :level => level).joins(:spell => :school).includes(:spell => :school).order("schools.name, spells.name")
    @available = @available.reduce({}) do |memo, ks|
      next memo if @spell_book.klass_spells.include? ks
      key = ks.spell.school.name
      val = [ks.spell.name, ks.id]
      if memo[key]
        memo[key] << val
      else
        memo[key] = [val]
      end
      memo
    end
    @current = @spell_book.klass_spell_spell_books.includes(:klass_spell => :spell).order("level, spells.name")
  end

end
