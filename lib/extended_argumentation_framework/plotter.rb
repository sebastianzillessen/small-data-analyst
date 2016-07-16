module ExtendedArgumentationFramework
  class Plotter
    def initialize(framework, analysis)
      @framework = framework
      @analysis = analysis
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
      @nodes_in = @analysis.remaining_models.map { |m| m.int_name }
      @nodes_out = (@analysis.declined_models.map(&:int_name) & @framework.arguments.map(&:int_name))

      @analysis.impossible_models.map(&:reasons).flatten.uniq.map(&:argument).flatten.uniq.
          select { |a| @framework.arguments.map(&:int_name).include? a.int_name }.each { |a|
        if a.evaluate(@analysis)
          @nodes_in << a.int_name
        else
          @nodes_out << a.int_name
        end
      }

      "{ node[fillcolor=\"green\" style=\"filled\"] #{@nodes_in.join(" ")} }"+
          "{ node[fillcolor=\"red\" style=\"filled\"] #{@nodes_out.join(" ")} }"
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