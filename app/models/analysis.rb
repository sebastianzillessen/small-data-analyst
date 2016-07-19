class Analysis < ActiveRecord::Base

  default_scope { includes(:research_question, :dataset, :user, :possible_models).order(:created_at) }

  belongs_to :research_question
  belongs_to :dataset
  belongs_to :user
  has_many :all_possible_models, class_name: 'PossibleModel'
  has_many :possible_models, -> { where possible_models: {rejected: false} }, class_name: 'PossibleModel'
  has_many :impossible_models, -> { where possible_models: {rejected: true} }, class_name: 'PossibleModel'


  has_many :remaining_models, through: :possible_models, source: :model
  has_many :declined_models, through: :impossible_models, source: :model
  has_many :all_models, through: :all_possible_models, source: :model


  #has_and_belongs_to_many :impossible_models, -> { where("analyses_models.possible = ?", false) }, class_name: 'Model'

  has_many :query_assumption_results, autosave: true, dependent: :destroy
  has_many :open_query_assumptions, -> { where query_assumption_results: {ignore: false, result: nil} }, class_name: 'QueryAssumptionResult'

  validates :research_question, :dataset, presence: true
  validates :stage, presence: true
  before_validation :set_stage
  after_create :start


  def possible_models_after_stage(stage)
    self.all_possible_models
        .joins("LEFT OUTER JOIN reasons ON reasons.possible_model_id = possible_models.id")
        .having("MIN(reasons.stage) > #{stage} OR COUNT(reasons.id) = 0")
        .group("possible_models.id")
  end

  def start
    research_question.models.each do |m|
      pm = PossibleModel.create(model: m, analysis: self)
      if (m.evaluate(self))
        m.get_queries(self).each do |q|
          q = QueryAssumptionResult.new(analysis: self, query_assumption: q, result: nil, stage: self.stage)
          self.query_assumption_results << q if (q.valid?)
        end
      end
    end
  end


  def updated_query_assumption_result(q)
    if (q.result == false)
      self.possible_models.where(model: q.query_assumption.get_associated_models).each { |p| p.reject!(q.stage, q.query_assumption) }
      # update query_assumption_results and check if there is one which needs only to be answered for a not possible model anymore
      self.open_query_assumptions.where.not(id: q.id).each do |qar|
        if (qar.query_assumption.get_associated_models.any? && (qar.query_assumption.get_associated_models & self.remaining_models).empty?)
          qar.update(ignore: true)
        end
      end
    end
    if (q.result == true)
      # kill all query_assumptions that are attacked by this assumption
      self.open_query_assumptions.where(query_assumption: q.query_assumption.attacking).update_all(ignore: true)
    end
    if (done?)
      self.stage = 2
      As2Init.new(self)
    end
    save
  end


  def done?
    open_query_assumptions.empty?
  end

  def add_framework(arguments, framework, models_excluded=nil)
    @frameworks ||= {}
    if (framework.arguments.any? && framework.edges.any?)
      @frameworks[arguments] = {
          framework: framework,
          excluded_models: models_excluded,
          plotter: ExtendedArgumentationFramework::Plotter.new(framework, arguments_hold: arguments)
      }
    end
    @frameworks
  end

  def frameworks()
    unless @frameworks
      As2Init.new(self)
    end

    @frameworks || {}
  end

  private

  def set_stage
    self.stage ||= 1
  end


end