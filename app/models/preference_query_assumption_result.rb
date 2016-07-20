class PreferenceQueryAssumptionResult < QueryAssumptionResult
  belongs_to :preference
  validates :preference, presence: true
  before_update :ignore_other_associated_models, if: :result_changed?


  private

  # Todo: test this.
  def ignore_other_associated_models
    if (self.result?)
      self.analysis.open_query_assumptions.where(
          query_assumption: self.preference.assumptions.
              where.not(id: self.query_assumption.id)
      ).update_all(ignore: true)
    end
  end
end