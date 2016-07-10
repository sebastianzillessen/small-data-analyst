module ExtendedArgumentationFramework
  class Solver
    BLUE = 1
    RED = 0

    attr_reader :framework

    def initialize(framework)
      @framework = if (framework.is_a?(String) || framework.is_a?(Array))
                     Framework.new(framework)
                   elsif (framework.is_a? Framework)
                     framework
                   else
                     raise ArgumentError, "Init a solver with a argumentation framework!"
                   end
    end

    def preferred_extensions
      @preferred_extensions ||= calc_preferred
    end

    def acceptable_arguments(subset, x)
      raise ArgumentError, "Subset is not a subset of framework.arguments" unless subset?(subset, framework.arguments)
      attacks = @framework.attacks.reject { |a| !a.succeeds_wrt(subset, @framework) }
      attacks_on_attacks = @framework.attacks_on_attacks
      colors = {}
      attacks.select { |a| a.target == x }.each { |a| colors[a] = BLUE }

      puts "\nColors are:"
      colors.each { |c, v| puts "#{c}=#{v}" }

      change_in_attack_color = false
      begin
        change_in_attack_color = false

        # for y \in X s.t. y ->S x or <y,<u,v>> is BLUE do
        #   for each z \in S s.t. z ->S y
        #     # color z ->S y RED
        #   end
        # end
        framework.arguments.select { |y|
          framework.attacks(y).select { |e| e.target == x && e.succeeds_wrt(subset, framework) }.any? ||
              framework.attacks_on_attacks(y).select { |yuv| colors[yuv] == BLUE }.any?
        }.each do |y|
          subset.map { |z| framework.attacks(z).select { |a| a.target == y } }.flatten.each do |edge|
            if (colors[edge] != RED)
              colors[edge] = RED
              change_in_attack_color = true
              puts "(1) Color #{edge} in RED"
            end
          end
        end
        # for z ->S y colored RED do
        #   color each attack <v,<z,y>> in D BLUE
        # end for
        colors.select { |e, v| v == RED }.each do |e, v|
          framework.attacks_on_attacks.select { |a| a.target == e }.each do |aoa|
            if (colors[aoa] != BLUE)
              colors[aoa] = BLUE
              change_in_attack_color = true
              puts "(2) Color #{aoa} in RED"
            end
          end
        end

        puts "\nColors are:"
        colors.each { |c, v| puts "#{c}=#{v}" }
        puts "-----"
      end while change_in_attack_color

      change_in_d = false

      begin
        puts "New attack set: #{attacks.map(&:to_s).join("; ")}"
        puts "New a_o_a  set: #{attacks_on_attacks.map(&:to_s).join("; ")}"
        change_in_d = false
        # if exists y \in X s.t. <y, <v,w>> is BLUE AND there is no u ->S y coloured RED then
        #  A := A\{<v,w>}
        #  D := D\{<y,<v,w>>}
        # end
        colors.select { |e, v| v == BLUE }.select { |e, v| colors.select { |e2, v| v==RED && e2.target == e.source && e2.succeeds_wrt(subset, framework) }.empty? }.each do |edge, v|
          # edge is <y, <v,w>>
          puts "(3) removed from attacks #{edge.target}"
          attacks -= [edge.target]
          if attacks_on_attacks.delete(edge)
            puts "(3) removed from a_on_a #{edge}"
            change_in_d = true
          end
        end
        # if exists z \in S s.t. (<z,y> is RED with <y,<u,v>> is BLUE) and there is no <p,<z,y>> in D
        #   D := D \ {<y,<u,v>>}
        # end
        subset.each { |z|
          # (<z,y> is RED with <y,<u,v>> is BLUE)
          framework.attacks(z).each { |zy|
            y = zy.target
            if (colors[zy] == RED)
              framework.attacks_on_attacks(y).select { |yuv|
                colors[yuv] == BLUE
              }.each do |yuv|
                # and there is no <p,<z,y>> in D}
                if (attacks_on_attacks.select { |aoa| aoa.target == zy }.empty?)
                  if (attacks_on_attacks.delete(yuv))
                    puts "(4) removed #{yuv}"
                    change_in_d = true
                  end
                end
              end
            end
          }
        }
      end while change_in_d

      # remove from attacks on attacks all edges that point on a not existing terminal edge
      attacks_on_attacks.select! do |edge|
        while (edge.target.is_a?(Edge))
          edge = edge.target
        end
        attacks.include?(edge)
      end
      puts "Final sets:"
      puts attacks
      puts attacks_on_attacks
      return false unless attacks_on_attacks.empty?
      return


    end

    private


    # is a a subset of b?
    def subset?(a, b)
      (b & a) == a
    end

    def find_pref(labelling, cand =[])
      # check if candidate labelling exists where current labelling is a subset of
      return cand if cand.select { |l| subset?(labelling.arg_in, l.arg_in) }.any?
      #if labelling does not have an argument illegally labelled in then Remove from Cand all  subsets of the current labelling
      if (labelling.illegally_labelled_ins.empty?)
        cand.reject! { |l| subset?(l.arg_in, labelling.arg_in) }
        cand << labelling
        return cand
      else
        if x = labelling.super_illegally_labelled_in
          cand = find_pref(labelling.step(x), cand)
        else
          labelling.illegally_labelled_ins.each do |x|
            cand << find_pref(labelling.step(x), cand)
          end
        end
        return cand
      end

    end

    def calc_preferred
      # 1) start with all arguments and relations labeled in
      # 2) correct the arguments that are illegally labeled in or out by so called transisition steps
      # 3) correct the attacks \subset D that are illegally labeld in or out.
      l = Labelling.new(framework)

      changed = true
      while changed
        changed = false
        # next illegally labeled in
        arg = framework.arguments.select { |a| a.illegally_in?(l) }.first
        # change it to out
        l.set(arg, Labels::OUT)
        x_and_all_attacked_by_x = [arg] + framework.attacks.select { |a| a.source == arg }.map { |a| a.target }
        x_and_all_attacked_by_x.each do |a|
          if (a.illegally_out?(l))
            l.set(a, Labels::UNDEC)
          end
        end
      end
      []
    end


  end
end