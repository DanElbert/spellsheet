
current_width = pdf.bounds.right - pdf.bounds.left
padding = 3
check_box_size = font_percent(75)
check_box_gutter = 2
title_font = "Arabian"
# Also has klass_spell_spell_books var!!

pdf.bounding_box([0, pdf.cursor], :width => current_width, :height => spell_block_height) do

  pdf.line_width 0.5

  pdf.transparent(spell.is_learned ? 1.0 : 0.25) do

    pdf.pad(padding) do
      pdf.indent(padding, padding) do

        top = pdf.cursor

        pdf.stroke do
          pdf.rectangle [0, top], check_box_size, check_box_size
          pdf.rectangle [check_box_size + check_box_gutter, top], check_box_size, check_box_size
          pdf.rectangle [(2 * (check_box_size + check_box_gutter)), top], check_box_size, check_box_size
        end

        pdf.formatted_text_box [
            { :text => "#{spell.name} ", :styles => [], :size => font_percent(100) },
            { :text => "(#{spell.short_components}) ", :size => font_percent(80) } ,
            { :text => "#{spell.formatted_school}", :size => font_percent(75) }],
          :at => [(3 * (check_box_size + check_box_gutter)), top],
          :height => font_percent(150)

        pdf.formatted_text_box [
            { :text => "#{(spell.short_description || "").gsub(/^\s+/, "")}",
              :styles => [:italic],
              :size => font_percent(75)
            } ],
          :at => [0, pdf.cursor - font_percent(150)],
          :height => font_percent(125),
          :overflow => :shrink_to_fit
      end
    end

    pdf.stroke do
      pdf.rounded_rectangle pdf.bounds.top_left, pdf.bounds.right, pdf.bounds.top, 2
    end

  end

  pdf.line_width 1
end
