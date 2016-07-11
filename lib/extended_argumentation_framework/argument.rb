module ExtendedArgumentationFramework
  class Argument
    attr_accessor :name

    def initialize(name)
      @name = name
    end

    def to_s
      "#{@name}"
    end

    def <=>(per)
      to_s <=> per.to_s
    end

    def ==(another_argument)
      return false if another_argument.nil? || !another_argument.is_a?(Argument)
      self.name == another_argument.name
    end

    def hash
      name.hash
    end

    def eql?(comparee)
      self == comparee
    end

    def illegally_in?(labelling)
      labelling.arg_in.include?(self) && !legally_in?(labelling)
    end

    def illegally_out?(labelling)
      labelling.arg_out.include?(self) && !legally_out?(labelling)
    end


    def legally_out?(labelling)
      #1. x ∈ out(LA) is legally OUT iff ∃(y, x) ∈ R s.t. LA(y)= IN and LR((y, x)) = IN
      labelling.R.select { |edge, label|
        edge.target == self &&
            labelling.la(edge.source) == Labels::IN &&
            label == Labels::IN
      }.any?
    end

    # @param x \in @x
    def legally_in?(labelling)
      #2. x ∈ in(LA) is legally IN iff ∀(y, x) ∈ R,
      # either LA(y)= OUT or LR((y, x)) = OUT.
      return false unless labelling.arg_in.select { |a| a == self }.any?
      all_attackers = labelling.R.select { |e, label| e.target == self }
                          .map { |e, label| e.source }
      all_attackers.reject { |y| labelling.la(y) == Labels::OUT || labelling.lr(Edge.new(y, self)) == Labels::OUT }.empty?
    end

    # @param x \in @x
    def legally_undec?(labelling)
      #raise RuntimeError, "Not implemented yet"
      #TODO: implement legally_undec?
      #3. x ∈ undec(LA) is legally UNDEC iff:
      #  (a) ¬∃(y, x) ∈ R such that LA(y) = IN and LR((y, x))= IN, and;
      #  (b) it is not the case that: ∀y ∈ A, (y, x) ∈ R implies LA(y) = OUT or LR((y, x)) = OUT

    end
  end
end
