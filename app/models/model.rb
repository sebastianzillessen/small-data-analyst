class Model < ActiveRecord::Base
  include IntName
  include Plottable
  after_update :int_invalidate_plots

  default_scope { order('name DESC') }

  has_and_belongs_to_many :research_questions, uniq: true
  has_many :possible_models, dependent: :destroy
  has_many :analyses, through: :possible_models
  has_and_belongs_to_many :assumptions, uniq: true
  belongs_to :user
  has_and_belongs_to_many :model_orders

  validates :name, presence: true, uniqueness: true
  validates :research_questions, presence: true


  def evaluate(analysis)
    assumptions.where("type NOT IN (?)", [QueryAssumption, QueryTestAssumption]).each do |a|
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
      assumptions.where("type NOT IN (?)", [QueryAssumption, QueryTestAssumption]).each do |a|
        queries << a.get_queries(analysis)
      end

      queries << assumptions.where("type IN (?)", [QueryAssumption, QueryTestAssumption])
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

  private

  def int_invalidate_plots
    if (self.changed & ['name', 'assumptions', 'research_questions']).any?
      self.research_questions.each { |r| r.plot.try(:destroy) }
      self.plot.try(:destroy)
    end
  end

end
