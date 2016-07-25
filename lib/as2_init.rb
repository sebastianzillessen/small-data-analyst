class As2Init


  def initialize(analysis)
    return nil unless (analysis.in_progress?)
    @analysis = analysis
    as2_inits
  end


  private

  def model_rules(stage)
    @analysis.possible_models_after_stage(stage).includes(:model).map(&:model).combination(2).map do |m, n|
      [
          m.int_name, n.int_name,
          "#{m.int_name}->#{n.int_name}",
          "#{n.int_name}->#{m.int_name}"
      ]
    end.flatten.uniq
  end

  def as2_inits
    all_done = false
    Preference.where(research_question: @analysis.research_question).order(:stage).all.select { |p| @analysis.user.ability.can? :read, p }.each do |preference|
      # if we find unanswered queryAssumptions we gonna stop adding them
      found_unanswered_on_this_stage = false
      if (@analysis.possible_models.count > 1)
        preference.arguments.each do |q|
          next unless (q.is_a? QueryAssumption)

          qar = PreferenceQueryAssumptionResult.new(
              analysis: @analysis,
              query_assumption: q,
              result: nil,
              stage: @analysis.stage,
              preference: preference)
          if (@analysis.open_query_assumptions.any?)
            found_unanswered_on_this_stage = true
          end
          if (qar.valid?)
            found_unanswered_on_this_stage = true
            @analysis.query_assumption_results << qar
          end
        end
      end

      if found_unanswered_on_this_stage
        all_done = false
        break
      else
        @analysis.stage = preference.stage + 1
        @analysis.save
        # lets see if we can make a decision
        # get all rules for answered query_assumptions
        arguments_hold = preference.arguments.select { |a| a && a.evaluate(@analysis) }

        rules = (preference.rules(arguments_hold)+model_rules(preference.stage)).join(",")
        puts "Generated rules for #{preference.name} are: #{rules}"
        framework = ExtendedArgumentationFramework::Framework.new(rules, name: "Extended Argumentation framework for stage #{preference.stage}")

        solver = ExtendedArgumentationFramework::Solver.new(framework)
        subset = arguments_hold.map { |a| ExtendedArgumentationFramework::Argument.new(a.int_name) }

        @analysis.possible_models.each do |p|
          if (solver.acceptable_arguments(subset, ExtendedArgumentationFramework::Argument.new(p.model.int_name)) == false)
            p.reject!(@analysis.stage, *(subset+[preference]))
          end
        end
        @analysis.add_framework(arguments_hold, framework)

        all_done = true
      end
    end
    if (all_done)
      @analysis.in_progress = false
      @analysis.save
    end
  end



end