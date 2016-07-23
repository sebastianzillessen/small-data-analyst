require 'r_script_execution'

class TestAssumption < Assumption
  include RCodeExecutor
  has_many :dataset_test_assumption_results, foreign_key: :assumption_id, dependent: :destroy

  after_save :update_dataset_test_assumptions_results
  #after_create :generate_dataset_test_assumptions_results


  def evaluate(analysis_or_dataset)
    dataset = ensure_dataset(analysis_or_dataset)
    cached = self.dataset_test_assumption_results.where(dataset: dataset).first.try(:result)
    return cached unless cached.nil?
    @evaluate ||= begin
      res = eval_internal(dataset)
      dtar = self.dataset_test_assumption_results.where(dataset: dataset).first
      if (dtar)
        dtar.update_attributes(result: res)
      else
        self.dataset_test_assumption_results << DatasetTestAssumptionResult.new(dataset: dataset, result: res)
      end
      res
    end
  end


  def eval_internal(dataset)
    # TODO: Provide better output for user why the assumption does not hold
    return false unless check_dataset_mets_column_names(dataset) if required_dataset_fields.any?
    RScriptExecution.execute r_code, dataset.data
  rescue Exception => e
    puts "Error on evaluation of:\n#{r_code}"
    puts "ERROR: #{e.inspect}\n While running on: #{self.inspect}"
    false
  end

  protected


  private
  def generate_dataset_test_assumptions_results
    Dataset.all.each do |d|
      self.dataset_test_assumption_results << DatasetTestAssumptionResult.create(dataset: d, test_assumption: self)
    end
  end


  def update_dataset_test_assumptions_results
    if (self.changed & ['r_code', 'required_dataset_fields']).any?
      dataset_test_assumption_results.each { |dtar| dtar.update }
    end
  end



end