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
    return cached.plot unless cached.nil? || cached.plot.nil? || !cached.valid? || !cached.plot.valid?
    if (cached)
      cached.destroy
    end

    filename = eval_internal(dataset)
    plot = Plot.new(filename: filename, object: self)
    dtar = self.query_test_assumption_plots.where(dataset: dataset).first
    if (dtar)
      dtar.update_attributes(plot: plot)
    else
      self.query_test_assumption_plots << QueryTestAssumptionPlot.new(dataset: dataset, plot: plot)
    end
    plot
  end

  def eval_internal(dataset)
    # TODO: Provide better output for user why the assumption does not hold
    return false unless check_dataset_mets_column_names(dataset) if required_dataset_fields.any?
    filename = File.join(Plot::BASE_URL, "r_plot_#{SecureRandom.hex(10)}.png")
    if RScriptExecution.retrieveFile(r_code, dataset.data, filename)
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