module ExtendedArgumentationFramework
  class Edge
    attr_accessor :target
    attr_reader :source

    def initialize(source, target=nil)
      self.source =source
      self.target= target
    end

    def target=(t)
      raise "Target must be an argument or an edge but was #{t.class}" unless t.is_a?(Argument) || t.is_a?(Edge) || t.nil?
      @target = t
    end


    def simple_attack?
      @target.is_a?(Argument)
    end

    def inverse
      Edge.new(@target, @source)
    rescue Exception => e
      raise "Cannot build an inverse of #{self}: #{e}"
    end

    def to_s
      "(#{@source} -> #{@target})"
    end

    def ==(other)
      return false unless other.is_a? Edge
      return false if other.nil?
      self.source == other.source && self.target == other.target
    end

    def hash
      (source.hash+target.hash)
    end

    def eql?(comparee)
      self == comparee
    end


    def succeeds_wrt(s, framework)
      # (x ->S y) iff there is no z \in S for which <z, <x,y>> \in D
      s.each do |z|
        return false if framework.attacks_on_attacks(z).select { |a| a.target == self }.any?
      end
      return true
    end


    def illegally_in?(labelling)
      labelling.edge_in.include?(self) && !legally_in?(labelling)
    end

    def illegally_out?(labelling)
      labelling.edge_out.include?(self) && !legally_out?(labelling)
    end


    def legally_out?(labelling)
      #1. (y, x) ∈ out(LR) is legally OUT iff ∃ (z,(y, x)) ∈ D s.t. LA(z) = IN
      labelling.edges_with_target(self).select { |e, l| labelling.la(e.source) == Labels::IN }.any?
    end

    # @param x \in @a \and @d
    def legally_in?(labelling)
      # 2. (y, x) ∈ in(LR) is legally IN iff ∀ (z,(y, x)) ∈ D, LA(z) = OUT
      labelling.edges_with_target(self).select { |e, l| labelling.la(e.source) != Labels::OUT }.empty?
    end

    # @param x \in @a \and @d
    def legally_undec?(labelling)
      # 3. (y, x) ∈ undec(LR) is legally UNDEC iff
      #  (a) ¬∃ (z,(y, x)) ∈ D s.t. LA(z) = IN
      #  (b) it is not the case that: ∀z ∈ A, (z,(y, x)) ∈ D implies LA(z) = OUT
      labelling.edges_with_target(self).select { |e, l| labelling.la(e.source) == Labels::IN }.empty? &&
          labelling.edges_with_target(self).select { |e, l| labelling.la(e.source) != Labels::OUT }.any?
    end


    private


    def source=(source)
      raise "Source must be an argument" unless source.is_a? Argument
      @source = source
    end
  end
end
