module ExtendedArgumentationFramework
  class Labelling

    attr_reader :A, :R

    def initialize(framework)
      @framework = framework
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

    def clone
      l = Labelling.new(@framework)
      self.A.each { |k, v| l.set(k, v) }
      self.R.each { |k, v| l.set(k, v) }
      l
    end


    def step(x)
      # clone labelling
      l = self.clone
      l.set(x, Labels::OUT)
      # todo: complete transition step
      all = [x] + @framework.attacks(x).map { |a| a.target }
      all.each do |a|
        if (a.illegally_out?(l))
          l.set(a, Labels::UNDEC)
        end
      end
      return l
    end

    def ==(other)
      return false if other.nil?
      return false unless other.is_a? Labelling
      return false if other.instance_variable_get(:@framework) != @framework
      other.R == self.R && other.A == self.A
    end

    def to_s
      "IN: #{arg_in.map(&:to_s).join(",")}\n"+
          "OUT: #{arg_out.map(&:to_s).join(",")}\n"+
          "UND: #{arg_undec.map(&:to_s).join(",")}"
    end

    def eql?(comparee)
      self == comparee
    end

    def hash
      to_s.hash
    end


    def illegally_labelled_ins
      arg_in.select { |a| a.illegally_in?(self) }
    end

    def super_illegally_labelled_in
      res = []
      illegally_labelled_ins.each do |a|
        if edges_with_target(a).select { |e| e.legally_in?(self) }.map { |e| e.source }.select { |a| a.legally_in?(self) }.any?
          res << a
        end
      end
      res.uniq
    end

    def arg_in
      # labelled in arguments
      @A.select { |k, v| v == Labels::IN }.map { |k, v| k }.sort_by(&:name)
    end

    def arg_out
      # labelled out arguments
      @A.select { |k, v| v == Labels::OUT }.map { |k, v| k }.sort_by(&:name)
    end

    def arg_undec
      # labelled undec arguments
      @A.select { |k, v| v == Labels::UNDEC }.map { |k, v| k }.sort_by(&:name)
    end


    def edges_with_target(a)
      @R.select { |e, l| e.target == a }.map { |k, v| k }.sort_by(&:to_s)
    end

    def edge_in
      # labelled in arguments
      @R.select { |k, v| v == Labels::IN }.map { |k, v| k }.sort_by(&:to_s)
    end

    def edge_out
      # labelled out arguments
      @R.select { |k, v| v == Labels::OUT }.map { |k, v| k }.sort_by(&:to_s)
    end

    def edge_undec
      # labelled undec arguments
      @R.select { |k, v| v == Labels::UNDEC }.map { |k, v| k }.sort_by(&:to_s)
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
