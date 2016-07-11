class As2Init


  def initialize(analysis)
    @analysis = analysis
    fw = build_fw
  end


  private

  def model_rules
    @analysis.possible_models.combination(2).map do |m, n|
      ["#{m.int_name}->#{n.int_name}",
       "#{n.int_name}->#{m.int_name}"]
    end.flatten
  end

  def as2_inits
    found_unanswered_on_this_stage= false

    AS2::AS2.subclasses.sort_by(&:level).each do |c|
      puts "adding for #{c}"
      qas = c.arguments.map { |a| QueryAssumption.find_or_create_by(name: a, question: a) }
      # if we find unanswered queryAssumptions we gonna stop adding them
      found_unanswered_on_this_stage = false
      qas.each do |q|
        qar = QueryAssumptionResult.new(analysis: @analysis, query_assumption: q, result: nil)
        if (@analysis.query_assumption_results.select { |q| q == qar && (q.result.nil? && !q.ignore?) }.any?)
          found_unanswered_on_this_stage = true
        end
        if (qar.valid?)
          found_unanswered_on_this_stage = true
          @analysis.query_assumption_results << qar
        end
      end
      if found_unanswered_on_this_stage
        break
      else
        # lets see if we can make a decision
        # get all rules for answered query_assumptions
        arguments_hold = c.arguments.select { |a| @analysis.query_assumption_results.select { |qar| qar.query_assumption.name == a && qar.result == true && !qar.ignore? }.present? }.map { |a| a }
        framework = ExtendedArgumentationFramework::Framework.new((c.rules(arguments_hold)+model_rules).join(","))
        solver = ExtendedArgumentationFramework::Solver.new(framework)
        subset = arguments_hold.map { |a| ExtendedArgumentationFramework::Argument.new(a) }
        puts framework
        @analysis.possible_models.each do |p|
          if (solver.acceptable_arguments(subset, ExtendedArgumentationFramework::Argument.new(p.int_name)) == false)
            puts "Removing possible model: #{p.name}"
            binding.pry
            @analysis.possible_models -= [p]
          end
        end
      end
    end
    []
  end

  def build_fw
    fw = model_rules
    fw += as2_inits
    fw
  end


end