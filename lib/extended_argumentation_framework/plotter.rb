module ExtendedArgumentationFramework
  class Plotter
    def initialize(framework, options={})
      @framework = framework
      @options = {
          arguments_hold: [],
          plot_acceptability: true
      }
      @options.merge!(options)

      if @options[:plot_acceptability]
        @arguments_hold = options[:arguments_hold].map { |a| ExtendedArgumentationFramework::Argument.new(a.name) }
        @solver = Solver.new(framework)
      else
        @arguments_hold=[]
      end
    end

    def to_png
      require 'graphviz'
      dir = "public/images"
      FileUtils.mkdir_p(dir+'/frameworks') unless File.exists?(dir+'/frameworks')
      path = "frameworks/framework_#{Time.now.to_i}_#{SecureRandom.hex(5)}.png"
      GraphViz.parse_string(to_dot).output(png: "#{dir}/#{path}")
      path
    end

    private


    def dot_nodes

      @nodes_in =[]
      @nodes_out = []
      @nodes_undec = []
      @framework.arguments.reject { |a| @arguments_hold.include?(a) }.each do |a|

        res = @options[:plot_acceptability] ? @solver.acceptable_arguments(@arguments_hold, a) : nil
        if (res.nil?)
          @nodes_undec << a.int_name
        elsif res
          @nodes_in << a.int_name
        else
          @nodes_out << a.int_name
        end
      end

      res = ""
      res << "{ node[fillcolor=\"green\" style=\"filled\"] #{@nodes_in.join(" ")} }" if @nodes_in.any?
      res << "{ node[fillcolor=\"green\" style=\"filled\" shape=\"box\"] #{@arguments_hold.map(&:int_name).join(" ")} }" if @arguments_hold.any?
      res << "{ node[fillcolor=\"red\" style=\"filled\"] #{@nodes_out.join(" ")} }" if @nodes_out.any?
      res << "{ node[fillcolor=\"grey\" style=\"filled\"] #{@nodes_undec.join(" ")} }" if @nodes_undec.any?
      res
    end

    def dot_tempnodes
      res = @framework.attacks_on_attacks.map do |a|
        edge_name="#{a.target.source.int_name}__#{a.target.target.int_name}"
        "#{edge_name} [group=#{edge_name} width=0 shape=point]"
      end.flatten.uniq

      if (res.any?)
        res.join(";")
      end
    end

    def dot_edges_without_arrow
      res = @framework.attacks_on_attacks.map do |a|
        attr = if ((@nodes_in+@arguments_hold.map(&:int_name)).include?(a.source.int_name))
                 "[style=dashed]"
               end
        "#{a.target.source.int_name} -> #{a.target.source.int_name}__#{a.target.target.int_name} #{attr}"
      end
      if (res.any?)
        "{edge[arrowhead=none] #{res.join("; ")}}"
      end
    end

    def dot_edges
      res = @framework.attacks_on_attacks.map { |a|
        attr = if ((@nodes_in+@arguments_hold.map(&:int_name)).include?(a.source.int_name))
                 "[style=dashed]"
               end
        "#{a.target.source.int_name}__#{a.target.target.int_name} -> #{a.target.target.int_name} #{attr}"
      }

      res <<@framework.attacks_on_attacks.map { |a| "#{a.source.int_name} -> #{a.target.source.int_name}__#{a.target.target.int_name}" }
      res << (@framework.attacks-@framework.attacked_edges).map { |e| "#{e.source.int_name} -> #{e.target.int_name}" }
      res = res.flatten.uniq
      if (res.any?)
        res.join(";")
      end
    end

    def to_dot
      "digraph G {
      #{dot_tempnodes}
      #{dot_nodes}
      #{dot_edges_without_arrow}
      #{dot_edges}
      }".tap { |x| puts x }
    end


  end
end