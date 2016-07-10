module ExtendedArgumentationFramework
  class Labelling

    attr_reader :A, :R

    def initialize(framework)
      @A = {}
      framework.arguments.each { |a| @A[a]= Labels::IN }
      @R = {}
      framework.edges.each { |e| @R[e]= Labels::IN }
    end


    def set(element, label)
      if (element.is_a? Argument)
        @A[element] = label
      elsif (element.is_a? Edge)
        @R[element] = label
      else
        raise ArgumentError, "Element must be Edge or Argument but was #{element.class}"
      end
    end

    def la(argument)
      a = @A.select { |a| a == argument }.first
      if a
        a[1]
      else
        raise ArgumentError, "Cannot find the argument #{argument} in this labelling."
      end
    end

    def lr(edge)
      a = @R.select { |e| e == edge }.first
      if a
        a[1]
      else
        raise ArgumentError, "Cannot find the edge #{edge} in this labelling."
      end
    end


    def step(x)
      set(x, Labels::OUT)
      # todo: complete transition step
    end

    def illegally_labelled_ins
      arg_in.select { |a| a.illegally_in?(self) }
    end

    def super_illegally_labelled_in
      illegally_labelled_ins.each do |a|
        if edges_with_target(a).select { |e| e.legally_in?(labelling) }.map { |e| e.source }.select { |a| a.legally_in?(self) }.any?
          return a
        end
      end
    end

    def arg_in
      # labelled in arguments
      @A.select { |k, v| v == Labels::IN }.map { |k, v| k }
    end

    def arg_out
      # labelled out arguments
      @A.select { |k, v| v == Labels::OUT }.map { |k, v| k }
    end

    def arg_undec
      # labelled undec arguments
      @A.select { |k, v| v == Labels::UNDEC }.map { |k, v| k }
    end


    def edges_with_target(a)
      @R.select { |e, l| e.target == a }
    end

    def edge_in
      # labelled in arguments
      @R.select { |k, v| v == Labels::IN }.map { |k, v| k }
    end

    def edge_out
      # labelled out arguments
      @R.select { |k, v| v == Labels::OUT }.map { |k, v| k }
    end

    def edge_undec
      # labelled undec arguments
      @R.select { |k, v| v == Labels::UNDEC }.map { |k, v| k }
    end

    def admissible?
      #1. no x ∈ A is illegally IN or illegally OUT
      @A.each { |a, l| return false if a.illegally_in?(self) || a.illegally_out?(self) }
      #2. no (y, x) ∈ R is illegally IN or illegally OUT
      @R.each { |e, l| return false if e.illegally_in?(self) || e.illegally_out?(self) }
      #3. ∀x, y ∈ in(LA), it is not the case that (y, x) ∈ R and (x, y) ∈ R
      arg_in.combination(2).each do |x, y|
        return false if @R.include?(Edge.new(x, y)) && @R.include?(Edge.new(y, x))
      end
      return true
    end

    def stable?
      # L is stable iff L is admissible, and undec(LA) = ∅, undec(LR) = ∅.
    end
  end
end
