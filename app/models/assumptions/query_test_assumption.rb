class QueryTestAssumption < QueryAssumption
  include RCodeExecutor

  has_many :query_test_assumption_plots, dependent: :destroy

  after_save :update_query_test_assumption_plots


  def evaluate(analysis)
    analysis.query_assumption_results.where(query_assumption: self).first.try(:result)
  end


  def graph(dataset_or_analysis)
    dataset = ensure_dataset(dataset_or_analysis)
    cached = self.query_test_assumption_plots.where(dataset: dataset).first
    return cached.plot unless cached.nil? || cached.plot.nil? || !cached.valid? || !cached.plot.valid? || !cached.plot.file_exists?

    cached.destroy if (cached)

    cached = QueryTestAssumptionPlot.new(dataset: dataset, query_test_assumption: self)
    filename = eval_internal(dataset)
    cached.plot = Plot.new(filename: filename, object: cached)

    unless (cached.plot.valid? || !cached.plot.file_exists?)
      raise RuntimeError, "The plot could not be generated: #{cached.plot.errors.full_messages.join(". ")}"
    end

    if cached.valid? && cached.save!
      cached.plot.save!
      self.query_test_assumption_plots << cached
      self.save!
    else
      Delayed::Job.enqueue(FileDeleterJob.new(plot.filename), run_at: 5.minutes.from_now)
    end

    cached.plot
  end

  def eval_internal(dataset)
    # TODO: Provide better output for user why the assumption does not hold
    return false unless check_dataset_mets_column_names(dataset) if required_dataset_fields.any?
    filename = RScriptExecution.retrieveFile(r_code, dataset.data)
    if filename
      filename
    else
      raise RuntimeException, "The RScript did not set the 'result' variable to true when generating a picture."
    end
  end

  private

  def update_query_test_assumption_plots
    if (self.changed & ['r_script', 'required_dataset_fields']).any?
      query_test_assumption_plots.each { |qtap| qtap.update }
    end
  end

end