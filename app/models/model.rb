class Model < ActiveRecord::Base
  default_scope { order('name DESC') }
  has_and_belongs_to_many :research_questions, uniq: true
  has_many :possible_models, dependent: :destroy
  has_many :analyses, through: :possible_models
  has_and_belongs_to_many :assumptions,
                          uniq: true
  belongs_to :user

  validates :name, presence: true, uniqueness: true
  validates :research_questions, presence: true

  def evaluate_critical(analysis)
    assumptions.select(&:critical).select { |a| a.class != QueryAssumption }.each do |a|
      unless (a.evaluate_critical(analysis))
        analysis.possible_models.where(model: self).first.try(:reject!, analysis.stage, a)
        return false
      end
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

  def int_name
    name.parameterize.underscore
  end
end
