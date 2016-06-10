class Analysis < ActiveRecord::Base
  belongs_to :research_question
  belongs_to :dataset
  has_and_belongs_to_many :possible_models, class_name: 'Model'
  has_many :query_assumption_results

  validates :research_question, :dataset, presence: true


  def start
    research_question.models.each do |m|
      if (m.evaluate_critical)
        possible_models << m
        m.get_critical_queries.each do |q|
          q = QueryAssumptionResult.new(analysis: self, query_assumption: q, result: nil)
          self.query_assumption_results << q if (q.valid?)
        end
      end
    end
  end

  private


end
