module InvalidatePlots
  def self.included(base)
    base.extend(ClassMethods)
    base.class_eval do
      after_update :invalidate_plots
    end
  end

  module ClassMethods
    # define your class methods here
  end

  # define your instance methods here
  def invalidate_plots
    Plot.all.each do |p|
      o = p.object
      p.destroy
      o.delay(priority: 5).plot!
    end
  end

end