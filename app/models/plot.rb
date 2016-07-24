class Plot < ActiveRecord::Base
  BASE_URL = "public/images"

  belongs_to :object, polymorphic: true

  validates :filename, presence: true, uniqueness: true
  validates :object, presence: true
  #validate :file_exists
  validates :name, uniqueness: {scope: :object, allow_nil: true}

  before_destroy :delete_file
  after_create :upload_file

  def asset_path
    s3_url
  end

  def file_exists?
    file_exists
  end

  def s3_url
    @public_url ||= s3_object.public_url.tap { |x| puts "Public url is: #{x}" }
  end

  private

  def s3_object
    @s3 ||= S3_BUCKET.object("plot_#{self.id || SecureRandom.hex(5)}.png")
  end

  def upload_file
    s3_object.upload_file(filename, acl: 'public-read').tap { |x| puts "Upload of #{filename} done : #{x}" }
    Delayed::Job.enqueue(FileDeleterJob.new(filename), run_at: 1.minutes.from_now)
  end

  def file_name_valid?
    filename && File.exist?(filename)
  end

  def file_exists
    unless file_name_valid?
      errors.add(:filename, 'must exist')
      return false
    end
    return true
  end

  def delete_file
    if (file_name_valid?)
      File.delete(filename)
    end
  end
end
