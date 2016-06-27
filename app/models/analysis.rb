class Analysis < ActiveRecord::Base
  belongs_to :research_question
  belongs_to :dataset
  belongs_to :user
  has_and_belongs_to_many :possible_models, class_name: 'Model', dependent: :destroy
  has_many :query_assumption_results, autosave: true, dependent: :destroy

  validates :research_question, :dataset, presence: true


  def start
    research_question.models.each do |m|
      if (m.evaluate_critical(self))
        possible_models << m
        m.get_critical_queries(self).each do |q|
          q = QueryAssumptionResult.new(analysis: self, query_assumption: q, result: nil)
          self.query_assumption_results << q if (q.valid?)
        end
      end
    end
  end

  def updated_query_assumption_result(q)
    if (q.result == false)
      self.possible_models -= q.query_assumption.get_associated_models
      # update query_assumption_results and check if there is one which needs only to be answered for a not possible model anymore
      self.query_assumption_results.where(ignore: false, result: nil).where.not(id: q.id).each do |qar|
        if (qar.query_assumption.get_associated_models & self.possible_models).empty?
          puts "set #{qar.query_assumption.name} to ignore"
          qar.update(ignore: true)
        end
      end
    end
    save
  end

  private


end