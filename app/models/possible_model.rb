class PossibleModel < ActiveRecord::Base
  belongs_to :model
  belongs_to :analysis
  has_many :reasons

  validates :model, presence: true, uniqueness: {scope: :analysis}
  validates :analysis, presence: true, uniqueness: {scope: :model}


  def reject(stage, *res)
    puts "Rejecting #{model.name} because of #{reasons}"
    reasons= res.map do |r|
      if r.is_a?(ExtendedArgumentationFramework::Argument) || r.is_a?(String)
        Assumption.all.select { |a| a.int_name == r.to_s }
      elsif r.is_a?(Assumption) || r.is_a?(Preference)
        r
      else
        raise RuntimeError, "Don't know how to handle #{r}"
      end
    end
    self.rejected = true
    reasons.flatten.each do |r|
      self.reasons << Reason.new(argument: r, stage: stage)
    end
  end

  def reject!(stage, *reasons)
    reject(stage, *reasons)
    save!
  end

  def stage_of_first_rejection
    @stage_of_first_rejection ||= reasons.order(:stage).first.try(:stage)
  end
end
