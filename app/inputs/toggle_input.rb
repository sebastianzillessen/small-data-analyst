class ToggleInput < FormtasticBootstrap::Inputs::StringInput
  def to_html
    html_options = form_control_input_html_options
    html_options[:input_html]||={}
    html_options[:input_html][:data]||={}
    html_options[:input_html][:data][:indeterminate] = true
    bootstrap_wrapping do
      builder.input(method, html_options)
    end
  end

end