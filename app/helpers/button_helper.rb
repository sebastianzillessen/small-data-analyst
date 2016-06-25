module ButtonHelper
  def button_link_to(text, link, options={})
    options[:class] ||= ""
    options[:class] = options[:class].split(" ")
    options[:class] << "btn" unless options[:class].include?("btn")
    options[:class] << "btn-default" unless ['btn-default', 'btn-primary', 'btn-success', 'btn-info', 'btn-warning', 'btn-danger'].any? { |word| options[:class].include?(word) }
    options[:class] = options[:class].join(" ")
    link_to text, link, options
  end

  def link_icon_to(icon_name, link, options={})
    if (options[:title])
      options = {data: {toggle: 'tooltip', placement: 'bottom'}}.deep_merge(options)
    end
    button_link_to content_tag(:i, "", :class => "glyphicon glyphicon-#{icon_name}")+ (options[:text].present? ? content_tag(:span, options[:text]) : ''), link, options
  end
end
