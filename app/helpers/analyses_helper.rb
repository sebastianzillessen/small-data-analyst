module AnalysesHelper
  def collapse(id, options={})
    options = {expanded: true, parent: id+"_parent"}.merge(options)

    Haml::Engine.new(<<-TEXT
%a.pull-right(data-toggle="collapse" data-parent="##{options[:parent]}" href="##{id}" aria-expanded="#{options[:expanded]}" aria-controls="#{id}" class="#{!options[:expanded] ? 'collapsed' : ''}")
  .glyphicon.glyphicon-chevron-up
    TEXT
    ).render
  end
end
