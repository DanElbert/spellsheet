
width = pdf.bounds.right - pdf.bounds.left
gutter = 5
columns = 3.0
column_width = (width / columns)

@spell_levels.each do |level, spell_hash|
  spells = spell_hash.keys
  
  if get_available_height(pdf) < (4 * spell_block_height)
    pdf.start_new_page
  end

  pdf.pad(font_percent(150)) do
    pdf.text "Level #{level}", :size => font_percent(150), :styles => [:bold]
    pdf.stroke_horizontal_rule
  end
  
  top = pdf.cursor
  height = get_available_height(pdf)    
  rows_per_page = (height / spell_block_height)
  
  row_index = 1
  
  column_rows = (spells.size / columns).ceil
  column_sorted_spells = []
  
  (0...column_rows).each do |x|
    row = []
    (0...columns).each do |i|
      row << spells[x + (i * column_rows)]
    end
    column_sorted_spells << row
  end
  
  column_sorted_spells.each do |spell_set|
  
    spell_set.compact.each_with_index do |spell, col_index|

      spell_books = spell_hash[spell]
    
      pdf.bounding_box([column_width * col_index, top], :width => column_width) do
        pdf.indent(gutter / 2, gutter / 2) do
          pdf.pad_bottom(gutter / 2.0) do
            render "libraries/spell_sheet/spell", :pdf => pdf, :klass_spell => spell, :klass_spell_spell_books => spell_books
          end
        end
      end
      
    end
    
    if (row_index % rows_per_page) == 0
      pdf.start_new_page
      height = get_available_height(pdf)    
      rows_per_page = (height / spell_block_height).to_i
      row_index = 0
    end
    
    row_index += 1
    top = pdf.cursor
  end
  
end
