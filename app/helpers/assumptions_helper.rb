module AssumptionsHelper
  def glyphicon_critcal(assumption, opts={})
    if assumption.critical?
      Haml::Engine.new(".glyphicon.glyphicon-warning-sign", opts).render
    end
  end

  def glyphicon_type(assumption, opts={})
    if assumption.is_a? TestAssumption
      Haml::Engine.new(".glyphicon.glyphicon-tasks", opts).render
    elsif assumption.is_a? BlankAssumption
      Haml::Engine.new(".glyphicon.glyphicon-unchecked", opts).render
    elsif assumption.is_a? QueryAssumption
      Haml::Engine.new(".glyphicon.glyphicon-question-sign", opts).render
    end
  end
end
