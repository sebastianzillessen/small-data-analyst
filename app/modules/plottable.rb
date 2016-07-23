module Plottable
  def self.included(base)
    base.extend(ClassMethods)
    base.class_eval do
      has_one :plot, as: :object
      after_update :invalidate_plots
    end
  end

  module ClassMethods
    # define your class methods here
  end

  # define your instance methods here
  def plot!
    return plot if plot && plot.valid? && plot.file_exists?
    plot.destroy if (plot)
    f = ExtendedArgumentationFramework::Framework.new(graph_representation, auto_generate_nodes: true)
    file = ExtendedArgumentationFramework::Plotter.new(f, plot_acceptability: false, edges_style: 'dir=back style=dashed').to_png
    p=Plot.create(filename: "#{Plot::BASE_URL}/#{file}", object: self)
    p
  end

end