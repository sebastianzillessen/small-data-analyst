module Preferences
  class AS2
    def self.level
      raise RuntimeException, "Please overwrite"
    end

    def self.arguments
      raise RuntimeException, "Please overwrite"
    end

    def self.rules(r)
      [r].flatten.map { |r| all_rules[r.to_sym] }.flatten.uniq
    end
  end
end