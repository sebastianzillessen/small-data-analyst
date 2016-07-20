module TableHelper
  def user_td(object)
    if current_user.is_statistician?
      if object.user.nil?
        content_tag(:td, "-")
      elsif object.user == current_user
        content_tag(:td, "You")
      else
        content_tag(:td, object.user.email)
      end
    end
  end

  def table_headers(clazz, attributes, options={})
    headers =""
    attributes.each do |att|
      att = att.to_sym
      next if (att == :user) && !current_user.is_statistician?
      headers << content_tag(:th, clazz.human_attribute_name(att))
    end
    if options[:include_actions].present?
      headers << content_tag(:th, options[:include_actions].is_a?(String) ? options[:include_actions] : "Actions")
    end

    content_tag(:thead, content_tag(:tr, headers.html_safe))
  end
end