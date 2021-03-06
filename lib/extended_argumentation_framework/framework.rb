module ExtendedArgumentationFramework
  class Framework
    attr_reader :arguments


    # @param arguments: a set of atomic arguments as defined in Dung's framework as X
    # @param attacks:   a set of relation between arguments: A \subset X x X
    # @param attacks_on_attacks: a set of relation between arguments and attacks: D \subset X x A = X x (X x X)
    # TODO: Test auto_generate_nodes option
    # TODO: Test name option
    def initialize(*args)
      options = {}
      options = args.pop if args.last.is_a? Hash
      @options = {
          enforce_counter_attack: false,
          auto_generate_nodes: false
      }
      @options.merge!(options) if options

      if (args.length == 1)
        arguments, attacks, attacks_on_attacks = parse(args.first)
      elsif args.length == 3
        arguments, attacks, attacks_on_attacks = *args
      else
        raise ArgumentError, "a solver needs either (arguments, attacks, attacks_on_attacks) or a string representation to be initiated"
      end

      # remove all edges that contain nodes that are not listed in arguments
      attacks.select! { |a| [a.source, a.target].subseteq?(arguments) }
      attacks_on_attacks.select! { |a| [a.source, a.target.target, a.target.source].subseteq?(arguments) }

      self.arguments = arguments.sort_by(&:to_s)
      self.attacks = attacks.sort_by(&:to_s)
      self.attacks_on_attacks = attacks_on_attacks.sort_by(&:to_s)
      @options[:name] ||= "Framework with #{arguments.length} Arguments and #{edges.length} Edges."
    end

    def name=(name)
      @options[:name] = name
    end

    def name()
      @options[:name]
    end

    def to_s
      "Arguments: #{arguments.map(&:to_s)}\n"+
          "Attacks: #{attacks.map(&:to_s)}\n"+
          "Attacks on attacks: #{attacks_on_attacks.map(&:to_s)}"
    end


    def attacked_edges
      attacks_on_attacks.map do |a|
        a.target if a.target.is_a? Edge
      end
    end

    def edges(source=nil)
      (attacks(source) + attacks_on_attacks(source)).sort_by { |a| a.to_s }
    end

    def attacks_on_attacks(source=nil)
      return @attacks_on_attacks if source.nil?
      @attacks_on_attacks.select { |a| a.source == source }
    end

    def attacks(source=nil)
      return @attacks if source.nil?
      @attacks.select { |a| a.source == source }
    end


    private


    def arguments=(arguments)
      arguments.each do |a|
        raise "#{a} is not an argument" unless a.is_a? Argument
      end
      @arguments = arguments
    end

    def attacks=(attacks)
      attacks.each do |a|
        raise "#{a} is not a valid attack" unless a.is_a? Edge
        raise "#{a} can only be an attack from argument to argument" unless a.simple_attack?
      end
      @attacks = attacks
    end

    def attacks_on_attacks=(attacks_on_attacks)
      attacks_on_attacks.each do |a|
        raise "#{a} is not a valid attack" unless a.is_a? Edge
        raise "#{a} can only be an attack from argument to attack" if a.simple_attack?
        target_edge = a.target
        raise "The attack for #{a}->#{a.target} is missing in the set of attacks" unless attacks.include?(target_edge)
        raise "The counter attack for #{a}->#{target_edge} is missing in the set of attacks" if @options[:enforce_counter_attack] && !attacks.include?(target_edge.inverse)
      end
      @attacks_on_attacks = attacks_on_attacks
    end


    def parse_rule(rule)
      m = rule.match(/^\(?(?<source>\w+)(->(\((?<complex>.+)\)|(?<single>\w+)))?\)?$/)
      raise ArgumentError, "Cannot parse the rule: #{rule}. Match was: #{m.inspect}" unless m && m[:source]

      edge = Edge.new(Argument.new(m[:source]))
      if (m[:single])
        edge.target=Argument.new(m[:single])
      elsif (m[:complex])
        edge.target = parse_rule(m[:complex])
      end
      edge
    end

    def parse_argument(rule)
      m = rule.match(/^\(?(?<source>\w+)?\)?$/)
      return nil unless m && m[:source]
      Argument.new(m[:source])
    end

    def parse(text_or_array)
      text = if (text_or_array.is_a? Array)
               text_or_array.join(",")
             elsif text_or_array.is_a? String
               text_or_array
             else
               raise ArgumentError, "The provided parameter must be a comma seperated string or an array but was: #{text_or_array.class}"
             end
      edges = []
      arguments = []
      rules = text.gsub(/\s/, '').split(/\s*[\n,]\s*/)
      edge_rules = []
      rules.each do |rule|
        if (a=parse_argument(rule))
          arguments << a
        else
          edge_rules << rule
        end
      end
      edge_rules.each do |rule|
        edges << parse_rule(rule)
      end


      attacks = []
      attacks_on_attacks = []

      all_edges = edges
      while (edge=all_edges.pop) do
        arguments << edge.source if @options[:auto_generate_nodes]
        if (edge.target.is_a? Edge)
          all_edges << edge.target
          attacks_on_attacks << edge
        elsif edge.target.is_a? Argument
          arguments << edge.target if @options[:auto_generate_nodes]
          attacks << edge
        end
      end

      [arguments.uniq, attacks.uniq, attacks_on_attacks.uniq]

    end


  end
end
