module RCodeExecutor
  def self.included(base)
    base.extend(ClassMethods)
    base.class_eval do
      validates :r_code, presence: true
      serialize :required_dataset_fields, Array
      before_validation :parse_required_dataset_fields
      validate :r_code_syntax, if: :r_code_changed?
    end
  end

  module ClassMethods
    # define your class methods here
  end

  # define your instance methods here

  protected
  def ensure_dataset(analysis_or_dataset)
    if (analysis_or_dataset.is_a? Dataset)
      analysis_or_dataset
    elsif analysis_or_dataset.is_a? Analysis
      analysis_or_dataset.dataset
    else
      raise ArgumentError, 'No analysis or dataset provided'
    end
  end


  private
  def parse_required_dataset_fields
    if self.required_dataset_fields.is_a?(String) || self.required_dataset_fields.is_a?(Array)
      self.required_dataset_fields = self.required_dataset_fields.join(",").split(/\s*[,\s]\s*/).uniq.map(&:strip)
    end
  end

  def r_code_syntax
    #TODO: Validate R-Syntax
  end

  def check_dataset_mets_column_names(dataset)
    (required_dataset_fields - dataset.columns).empty?
  end

end