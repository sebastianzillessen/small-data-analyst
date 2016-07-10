module ExtendedArgumentationFramework
  class DungSolver
    def initialize(framework)
      @framework = if (framework.is_a?(String) || framework.is_a?(Array))
                     Framework.new(framework)
                   elsif (framework.is_a? Framework)
                     framework
                   else
                     raise ArgumentError, "Init a solver with a argumentation framework!"
                   end
      raise ArgumentError, "A Dung framework has no attacks on attacks!" unless (@framework.attacks_on_attacks.empty?)
    end

    def preferred_extensions
      @pe||=find_pref(Labelling.new(@framework)).uniq
    end

    def credulous_acceptable(x)
      preferred_extensions.each { |pe| return true if pe.arg_in.include?(x) }
      return false
    end

    def skeptical_acceptable(x)
      preferred_extensions.each { |pe| return false unless pe.arg_in.include?(x) }
      return true
    end

    private

    def find_pref(labelling, cand =[])
      # check if candidate labelling exists where current labelling is a subset of
      return cand if cand.select { |l|
        labelling.arg_in.subseteq?(l.arg_in)
      }.any?
      #if labelling does not have an argument illegally labelled in then Remove from Cand all  subsets of the current labelling
      if (labelling.illegally_labelled_ins.empty?)
        cand.reject! { |l| l.arg_in.subseteq?(labelling.arg_in) }
        cand << labelling
      else
        if x = labelling.super_illegally_labelled_in.first
          cand = find_pref(labelling.step(x), cand)
        else
          labelling.illegally_labelled_ins.each do |x|
            cand = find_pref(labelling.step(x), cand)
          end
        end
      end

      cand
    end
  end
end