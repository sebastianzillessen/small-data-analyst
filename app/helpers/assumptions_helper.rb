module AssumptionsHelper

  def glyphicon_type(assumption, opts={})
    clazz = 'tasks' if assumption.is_a? TestAssumption
    clazz = 'unchecked' if assumption.is_a? BlankAssumption
    clazz = 'question-sign' if assumption.is_a? QueryAssumption
    clazz = 'picture' if assumption.is_a? QueryTestAssumption
    tooltip = "{data:{toggle:'tooltip',placement:'bottom'},title: 'This is a #{assumption.class.name}'}"
    Haml::Engine.new(".glyphicon.glyphicon-#{clazz}#{tooltip}", opts).render
  end

  def r_code(code)
    if code.present?
      code.gsub(/\n/, '<br/>').html_safe
    else
      "<No code present>"
    end
  end


end
