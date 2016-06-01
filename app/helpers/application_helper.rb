module ApplicationHelper

  def nav_link(text, path, check=path)
    class_name = controller.controller_name.eql?(check) ? 'active' : ''

    content_tag(:li, class: class_name) do
      link_to text, path
    end
  end
end
