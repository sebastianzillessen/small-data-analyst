module Preferences
  class AS2
    def self.stage
      raise RuntimeException, "Please overwrite"
    end

    def self.arguments
      raise RuntimeException, "Please overwrite"
    end

    def self.rules(r)
      [r].flatten.map { |r| all_rules[r.name.to_sym] }.flatten.uniq
    end
  end
end