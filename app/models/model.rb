class Model < ActiveRecord::Base
  include IntName
  include Plottable

  default_scope { order('name DESC') }

  has_and_belongs_to_many :research_questions, uniq: true
  has_many :possible_models, dependent: :destroy
  has_many :analyses, through: :possible_models
  has_and_belongs_to_many :assumptions, uniq: true
  belongs_to :user

  validates :name, presence: true, uniqueness: true
  validates :research_questions, presence: true



  def evaluate(analysis)
    assumptions.where.not(type: QueryAssumption).each do |a|
      unless (a.evaluate(analysis))
        analysis.possible_models.where(model: self).first.try(:reject!, analysis.stage, a)
        return false
      end
    end
    return true
  end

  def get_queries(analysis)
    queries = []
    if (evaluate(analysis))
      # get sub queries
      # TODO: Replace selects with DB access
      assumptions.where.not(type: QueryAssumption).each do |a|
        queries << a.get_queries(analysis)
      end

      queries << assumptions.select { |a| a.class == QueryAssumption }
    end

    queries.flatten.uniq
  end


  def graph_representation
    rules = []
    rules << research_questions.map { |rq| "#{rq.int_name} -> #{self.int_name}" }
    assumptions.each do |a|
      rules << a.graph_representation(self)
    end
    rules
  end



end
