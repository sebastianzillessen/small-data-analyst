module InvalidatePlots
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    # define your class methods here
  end

  # define your instance methods here
  def invalidate_plots
    puts "INVALIDATA PLOTS #{self.inspect}"
    Plot.all.each do |p|
      o = p.object
      p.destroy
      if (o && o.respond_to?(:plot!))
        o.plot!
      end
    end
  end

  handle_asynchronously :invalidate_plots

end