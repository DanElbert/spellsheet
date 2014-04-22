prawn_document() do |pdf|

  def get_available_height(pdf)
    pdf.cursor - pdf.bounds.bottom
  end

  pdf.font_families.update("Arabian" => {
      :normal => Rails.root.to_s + "/lib/fonts/arabian.ttf"
  })

  pdf.text "#{@library.name }", :size => font_percent(200)
  
  render "libraries/spell_sheet/memorization_block", :pdf => pdf

  pdf.start_new_page

  render "libraries/spell_sheet/spell_book_summary", :pdf => pdf
  
  pdf.start_new_page
  
  if pdf.page_count % 2 == 0
    pdf.start_new_page
  end

  # Detailed spell sheets require full spell objects, which were not loaded by the controller
  spells = @library.collect_spells_with_levels.sort { |a, b| a[1].name <=> b[1].name }
  
  spells.each do |l, s|
    render "libraries/spell_sheet/detailed_spell", :pdf => pdf, :spell => s, :level => l
  end
  
  string = "<page>"
  options = { 
    :page_filter => lambda{ |pg| true },
    :at => [pdf.bounds.right - 57, 0],
    :width => 75,
    :align => :right }
    
  pdf.number_pages string, options
end
