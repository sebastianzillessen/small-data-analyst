module AnalysesHelper
  def collapse(id, parent=nil)
    parent = id+"_parent" if parent.nil?
    Haml::Engine.new(<<-TEXT
%a.pull-right(data-toggle="collapse" data-parent="##{parent}" href="##{id}" aria-expanded="true" aria-controls="#{id}")
  .glyphicon.glyphicon-chevron-up
    TEXT
    ).render
  end
end
