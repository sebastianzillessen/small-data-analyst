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

    def acceptable_arguments(subset, x)
      raise ArgumentError, "Subset is not a subset of framework.arguments" unless subset.subseteq?(framework.arguments)
      attacks = @framework.attacks.reject { |a| !a.succeeds_wrt(subset, @framework) }
      attacks_on_attacks = @framework.attacks_on_attacks
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
        colors.select { |e, v| v == BLUE }.select { |e, v| colors.select { |e2, v| v==RED && e2.target == e.source && e2.succeeds_wrt(subset, framework) }.empty? }.each do |edge, v|
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
          framework.attacks(z).each { |zy|
            y = zy.target
            if (colors[zy] == RED)
              framework.attacks_on_attacks(y).select { |yuv|
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
      return false unless attacks_on_attacks.empty?
      dung_framework = Framework.new(attacks.map(&:to_s).join(",")+",#{x}")
      return DungSolver.new(dung_framework).acceptable(x)
    end
  end
end