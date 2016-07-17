class PossibleModel < ActiveRecord::Base
  belongs_to :model
  belongs_to :analysis
  has_many :reasons

  validates :model, presence: true, uniqueness: {scope: :analysis}
  validates :analysis, presence: true, uniqueness: {scope: :model}


  def reject(stage, *reasons)
    reasons= reasons.map { |r| r.is_a?(Assumption) ? r : Assumption.find_or_create_by(name: r.to_s) }
    puts "Reject #{model} because of #{reasons}"
    self.rejected = true
    reasons.each do |r|
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
