class Analysis < ActiveRecord::Base
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
      if (m.evaluate_critical(self))
        m.get_critical_queries(self).each do |q|
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
      self.query_assumption_results.where(ignore: false, result: nil).where.not(id: q.id).each do |qar|
        if (qar.query_assumption.get_associated_models.any? && (qar.query_assumption.get_associated_models & self.remaining_models).empty?)
          qar.update(ignore: true)
        end
      end
    end
    if (q.result == true)
      # kill all query_assumptions that are attacked by this assumption
      self.query_assumption_results.where(ignore: false, result: nil, query_assumption: q.query_assumption.attacking).update_all(ignore: true)
    end
    if (done?)
      self.stage = 2
      As2Init.new(self)
    end
    save
  end


  def done?
    query_assumption_results.where(ignore: false, result: nil).empty?
  end

  def add_framework(arguments, framework, models_excluded=nil)
    @frameworks ||= {}
    @frameworks[arguments] = [framework, models_excluded]
    @frameworks
  end

  def frameworks()
    unless @frameworks
      As2Init.new(self)
    end

    @frameworks
  end

  private

  def set_stage
    self.stage ||= 1
  end


end