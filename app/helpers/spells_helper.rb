module SpellsHelper
  def effect_block(title, text)
    if text
      "<strong>#{title}</strong> #{text}<br />".html_safe
    end
  end
end
