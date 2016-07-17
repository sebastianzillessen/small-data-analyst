module Plottable
  def self.included(base)
    base.extend(ClassMethods)
    base.class_eval do
      has_one :plot, as: :object
      include InvalidatePlots
    end
  end

  module ClassMethods
    # define your class methods here
  end

  # define your instance methods here
  def plot!
    return plot if plot && plot.valid?
    puts "Plot: #{plot.try(:valid?)}:#{plot}"
    plot.destroy if (plot)
    puts "Plot: #{plot.try(:valid?)}:#{plot}"
    f = ExtendedArgumentationFramework::Framework.new(graph_representation, auto_generate_nodes: true)
    file = ExtendedArgumentationFramework::Plotter.new(f, plot_acceptability: false, edges_style: 'dir=back style=dashed').to_png
    p=Plot.create(filename: file, object: self)
    p
  end

end