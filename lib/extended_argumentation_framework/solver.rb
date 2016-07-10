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


    def to_dung_framework(subset, x, fw)
      raise ArgumentError, "#{subset.map(&:to_s).join(",")} is not a subset of #{fw.arguments.map(&:to_s).join(",")}" unless subset.subseteq?(fw.arguments)

      attacks = fw.attacks.reject { |a| !a.succeeds_wrt(subset, fw) }

      attacks_on_attacks = fw.attacks_on_attacks.clone
      colors = {}
      attacks.select { |a| a.target == x }.each { |a| colors[a] = BLUE }

      change_in_attack_color = false
      begin
        change_in_attack_color = false

        # for y \in X s.t. y ->S x or <y,<u,v>> is BLUE do
        #   for each z \in S s.t. z ->S y
        #     # color z ->S y RED
        #   end
        # end
        fw.arguments.select { |y|
          fw.attacks(y).select { |e| e.target == x && e.succeeds_wrt(subset, fw) }.any? ||
              fw.attacks_on_attacks(y).select { |yuv| colors[yuv] == BLUE }.any?
        }.each do |y|
          subset.map { |z| fw.attacks(z).select { |a| a.target == y } }.flatten.each do |edge|
            if (colors[edge] != RED)
              colors[edge] = RED
              change_in_attack_color = true
            end
          end
        end
        # for z ->S y colored RED do
        #   color each attack <v,<z,y>> in D BLUE
        # end for
        colors.select { |e, v| v == RED }.each do |e, v|
          fw.attacks_on_attacks.select { |a| a.target == e }.each do |aoa|
            if (colors[aoa] != BLUE)
              colors[aoa] = BLUE
              change_in_attack_color = true
            end
          end
        end
      end while change_in_attack_color

      change_in_d = false

      begin
        change_in_d = false
        # if exists y \in X s.t. <y, <v,w>> is BLUE AND there is no u ->S y coloured RED then
        #  A := A\{<v,w>}
        #  D := D\{<y,<v,w>>}
        # end
        colors.select { |e, v| v == BLUE }.select { |e, v| colors.select { |e2, v| v==RED && e2.target == e.source && e2.succeeds_wrt(subset, fw) }.empty? }.each do |edge, v|
          # edge is <y, <v,w>>
          attacks -= [edge.target]
          if attacks_on_attacks.delete(edge)
            change_in_d = true
          end
        end
        # if exists z \in S s.t. (<z,y> is RED with <y,<u,v>> is BLUE) and there is no <p,<z,y>> in D
        #   D := D \ {<y,<u,v>>}
        # end
        subset.each { |z|
          # (<z,y> is RED with <y,<u,v>> is BLUE)
          fw.attacks(z).each { |zy|
            y = zy.target
            if (colors[zy] == RED)
              fw.attacks_on_attacks(y).select { |yuv|
                colors[yuv] == BLUE
              }.each do |yuv|
                # and there is no <p,<z,y>> in D}
                if (attacks_on_attacks.select { |aoa| aoa.target == zy }.empty?)
                  if (attacks_on_attacks.delete(yuv))
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
      [attacks, attacks_on_attacks]
    end

    def framework_from_attacks(attacks)
      Framework.new(attacks.map(&:to_s).join(","))
    end

    def acceptable_arguments(subset, x, fw=nil)
      fw = @framework if (fw.nil?)
      attacks, attacks_on_attacks = to_dung_framework(subset, x, fw)
      # => we cannot make a clear statement if we still have attacks on attacks after the above algorithm
      # remove all attacks on attacks where the source is not in the attacks anymore
      used_arguments = attacks.map { |a| [a.source, a.target] }.flatten.uniq
      attacks_on_attacks.select! do |edge|
        used_arguments.include? edge.source
      end
      return nil unless attacks_on_attacks.empty?
      dung_framework = framework_from_attacks(attacks+[x])
      df = DungSolver.new(dung_framework)
      # => x is accepted in all preferred_extensions so it will always be true
      return true if (df.skeptical_acceptable(x))
      # => x is not accepted in all preferred extensions so we cannot make a decision on it
      return nil if (df.credulous_acceptable(x))
      # => x is not accepted in any preferred extension, so it will be false
      return false
    end

    def chain(x, *subsets)
      org_subsets = subsets.clone
      fw = @framework
      while (subset= subsets.delete_at(0))
        res = acceptable_arguments(subset, x, fw)
        return [res, org_subsets[0..org_subsets.index(subset)]] unless res.nil?
        # reduce the used framework
        a, aoa = to_dung_framework(subset, x, fw)
        fw = framework_from_attacks(a+aoa+[x])
      end
      return [nil, org_subsets]
    end
  end
end