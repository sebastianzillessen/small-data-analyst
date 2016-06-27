class Model < ActiveRecord::Base
  has_and_belongs_to_many :research_questions
  has_and_belongs_to_many :analyses
  has_and_belongs_to_many :assumptions
  belongs_to :user

  validates :name, presence: true, uniqueness: true
  validates :research_questions, presence: true


  def evaluate_critical(analysis)
    assumptions.select(&:critical).select { |a| a.class != QueryAssumption }.each do |a|
      return false unless (a.evaluate_critical(analysis))
    end
    return true
  end

  def get_critical_queries(analysis)
    queries = []
    if (evaluate_critical(analysis))
      # get sub critical queries
      assumptions.select(&:critical).select { |a| a.class != QueryAssumption }.each do |a|
        queries << a.get_critical_queries(analysis)
      end
      queries << assumptions.select(&:critical).select { |a| a.class == QueryAssumption }
    end

    queries.flatten.uniq
  end

end
