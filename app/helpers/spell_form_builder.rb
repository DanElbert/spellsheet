class SpellFormBuilder < ActionView::Helpers::FormBuilder

  def text_input(field, label_value = nil, options = {})
    label(field, label_value) + text_field(field, options)
  end

  def text_area_input(field, label_value = nil, options = {})
    label(field, label_value) + text_area(field, options)
  end

  def check_input(field)
    label(field) do
      check_box(field) + @template.content_tag(:span) { object.class.human_attribute_name(field) }
    end
  end

end