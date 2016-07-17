class Remove < ActiveRecord::Migration
  def self.up
    Assumption.all.select { |a| a.name.start_with?("CD") || a.name.start_with?("cd") }.each { |a| a.destroy }
  end

  def self.down

  end
end
