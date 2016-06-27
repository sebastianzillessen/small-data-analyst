module AssumptionsHelper
  def glyphicon_critcal(assumption, opts={})
    if assumption.critical?
      Haml::Engine.new(".glyphicon.glyphicon-warning-sign{data:{toggle:'tooltip',placement:'bottom'},title: 'This is a critical assumption'}", opts).render
    end
  end

  def glyphicon_type(assumption, opts={})
    clazz= ""
    if assumption.is_a? TestAssumption
      clazz = 'tasks'
    elsif assumption.is_a? BlankAssumption
      clazz = 'unchecked'
    elsif assumption.is_a? QueryAssumption
      clazz = 'question-sign'
    end
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
