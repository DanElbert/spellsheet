
tab = 7

pdf.pad_top(20) do
  pdf.font_size base_font_size do
    @library.spell_books.each do |sb|

      pdf.text "#{sb.name} [#{sb.formatted_pages}]"

      pdf.indent(tab) do
        level = -1

        kssbs = sb.klass_spell_spell_books.sort do |a, b|
          c = a.klass_spell.level <=> b.klass_spell.level
          if c == 0
            a.klass_spell.spell.name <=> b.klass_spell.spell.name
          else
            c
          end
        end

        kssbs.each do |kssb|
          if kssb.klass_spell.level != level
            pdf.text "Level #{kssb.klass_spell.level}"
            level = kssb.klass_spell.level
          end

          pdf.indent(tab) do
            pdf.transparent(kssb.is_learned ? 1.0 : 0.25) do
              pdf.text kssb.klass_spell.spell.name
            end
          end

        end
      end

    end
  end
end

