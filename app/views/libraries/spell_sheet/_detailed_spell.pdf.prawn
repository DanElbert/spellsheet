

def heading(pdf, text)
  pdf.stroke_horizontal_rule
  pdf.pad_top(4) { pdf.text text }
  pdf.stroke_horizontal_rule
end

#pdf.group do
  pdf.pad(font_percent(100)) do
    pdf.text "<b>#{spell.name}</b>", :size => font_percent(150), :inline_format => true
  end

  pdf.font_size base_font_size do

    pdf.pad_bottom(font_percent(75)) do
      pdf.text "<b>School</b> #{spell.school.name}; <b>Level</b> #{level}", :size => font_percent(100), :inline_format => true
    end

    heading(pdf, "CASTING")

    pdf.pad(font_percent(75)) do
      pdf.text "<b>Casting Time</b> #{spell.casting_time}", :inline_format => true
      pdf.text "<b>Components</b> #{spell.components}", :inline_format => true
    end

    heading(pdf, "EFFECT")

    pdf.pad(font_percent(75)) do
      pdf.text "<b>Range</b> #{spell.range}", :inline_format => true
      pdf.text "<b>Area</b> #{spell.formatted_area}", :inline_format => true if spell.area
      pdf.text "<b>Target</b> #{spell.targets}", :inline_format => true if spell.targets
      pdf.text "<b>Effect</b> #{spell.effect}", :inline_format => true if spell.effect
      pdf.text "<b>Duration</b> #{spell.formatted_duration}", :inline_format => true if spell.duration
      pdf.text "<b>Saving Throw</b> #{spell.saving_throw}; <b>Spell Resistance</b> #{spell.spell_resistence}", :inline_format => true
    end

    heading(pdf, "DESCRIPTION")

    pdf.pad(font_percent(75)) do
      pdf.text "#{(spell.description || '').gsub(/\.  /, ".\n\n")}"
    end
  end
#end

pdf.move_down [pdf.cursor, font_percent(200)].min