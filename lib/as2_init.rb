class As2Init


  def initialize(analysis)
    @analysis = analysis
    build_fw
  end


  private

  def model_rules(stage)
    @analysis.possible_models_after_stage(stage).map(&:model).combination(2).map do |m, n|
      [
          m.int_name, n.int_name,
          "#{m.int_name}->#{n.int_name}",
          "#{n.int_name}->#{m.int_name}"
      ]
    end.flatten.uniq
  end

  def as2_inits
    Preferences::AS2.subclasses.sort_by(&:stage).each do |c|
      puts "adding for #{c}"
      # if we find unanswered queryAssumptions we gonna stop adding them
      found_unanswered_on_this_stage = false
      if (@analysis.possible_models.count > 1)
        c.arguments.each do |q|
          next unless (q.is_a? QueryAssumption)
          qar = QueryAssumptionResult.new(analysis: @analysis, query_assumption: q, result: nil, stage: @analysis.stage)
          if (@analysis.query_assumption_results.where(result: nil, ignore: false).any?)
            found_unanswered_on_this_stage = true
          end
          if (qar.valid?)
            found_unanswered_on_this_stage = true
            @analysis.query_assumption_results << qar
          end
        end
      end

      if found_unanswered_on_this_stage
        break
      else
        @analysis.stage = c.stage
        @analysis.save
        # lets see if we can make a decision
        # get all rules for answered query_assumptions
        arguments_hold = c.arguments.select { |a| a && a.evaluate(@analysis) }
        puts "Holding arguments are: #{arguments_hold}"
        rules = (c.rules(arguments_hold)+model_rules(c.stage-1)).join(",")
        framework = ExtendedArgumentationFramework::Framework.new(rules, name: "Extended Argumentation framework for stage #{c.stage}")

        solver = ExtendedArgumentationFramework::Solver.new(framework)
        subset = arguments_hold.map { |a| ExtendedArgumentationFramework::Argument.new(a.name) }

        @analysis.possible_models.each do |p|
          if (solver.acceptable_arguments(subset, ExtendedArgumentationFramework::Argument.new(p.model.int_name)) == false)
            puts "Removing possible model: #{p.model.name}"
            p.reject!(@analysis.stage, *subset)
          end
        end
        # TODO: Store for models for which reason they are excluded.
        @analysis.add_framework(arguments_hold, framework)
        if @analysis.possible_models.count <= 1
          all_done = true
        end
      end
    end
  end

  def build_fw
    as2_inits
  end


end