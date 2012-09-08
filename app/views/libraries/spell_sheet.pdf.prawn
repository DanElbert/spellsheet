prawn_document() do |pdf|

  def get_available_height(pdf)
    pdf.cursor - pdf.bounds.bottom
  end

  pdf.text "#{@library.name }", :size => font_percent(200)
  
  render "libraries/spell_sheet/memorization_block", :pdf => pdf

  pdf.start_new_page

  render "libraries/spell_sheet/spell_book_summary", :pdf => pdf
  
  pdf.start_new_page
  
  if pdf.page_count % 2 == 0
    pdf.start_new_page
  end
  
  spells = @spell_levels.inject([]) { |memo, level| memo + level[1].keys }
  spells.sort! { |a, b| a.spell.name <=> b.spell.name }
  
  spells.each do |ks|
    render "libraries/spell_sheet/detailed_spell", :pdf => pdf, :klass_spell => ks
  end
  
  string = "<page>"
  options = { 
    :page_filter => lambda{ |pg| true },
    :at => [pdf.bounds.right - 57, 0],
    :width => 75,
    :align => :right }
    
  pdf.number_pages string, options
end
