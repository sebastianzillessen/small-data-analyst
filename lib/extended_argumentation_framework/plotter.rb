module ExtendedArgumentationFramework
  class Plotter
    def initialize(framework, arguments_hold)
      @framework = framework
      @arguments_hold = arguments_hold.map { |a| ExtendedArgumentationFramework::Argument.new(a.name) }
      @solver = Solver.new(framework)
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
      @framework.arguments.each do |a|
        res = @solver.acceptable_arguments(@arguments_hold, a)
        if (res.nil?)
          @nodes_undec << a.int_name
        elsif res
          @nodes_in << a.int_name
        else
          @nodes_out << a.int_name
        end
      end


      "{ node[fillcolor=\"green\" style=\"filled\"] #{@nodes_in.join(" ")} }
      { node[fillcolor=\"red\" style=\"filled\"] #{@nodes_out.join(" ")} }
      { node[fillcolor=\"grey\" style=\"filled\"] #{@nodes_undec.join(" ")} }
      "
    end

    def dot_tempnodes
      @framework.attacks_on_attacks.map do |a|
        "#{a.target.source.int_name}__#{a.target.target.int_name}"
      end
    end

    def dot_edges_without_arrow
      @framework.attacks_on_attacks.map do |a|
        attr = if (@nodes_in.include?(a.source.int_name))
                 "[style=dashed]"
               end
        "#{a.target.source.int_name} -> #{a.target.source.int_name}__#{a.target.target.int_name} #{attr}"
      end
    end

    def dot_edges
      res = @framework.attacks_on_attacks.map { |a|
        attr = if (@nodes_in.include?(a.source.int_name))
                 "[style=dashed]"
               end
        "#{a.target.source.int_name}__#{a.target.target.int_name} -> #{a.target.target.int_name} #{attr}"
      }

      res <<@framework.attacks_on_attacks.map { |a| "#{a.source.int_name} -> #{a.target.source.int_name}__#{a.target.target.int_name}" }
      res << (@framework.attacks-@framework.attacked_edges).map { |e| "#{e.source.int_name} -> #{e.target.int_name}" }
      res.flatten.uniq
    end

    def to_dot
      "digraph G {
        {node[width=0 shape=point] #{dot_tempnodes.join("; ")}}
        #{dot_nodes}
        {edge[arrowhead=none] #{dot_edges_without_arrow.join("; ")}}
        #{dot_edges.join("; ")}
      }"
    end


  end
end