class Plot < ActiveRecord::Base
  BASE_URL = "public/images"

  belongs_to :object, polymorphic: true

  validates :filename, presence: true, uniqueness: true
  validates :object, presence: true
  validate :file_exists
  validates :name, uniqueness: {scope: :object, allow_nil: true}

  before_destroy :delete_file


  def asset_path
    filename.gsub("#{BASE_URL}/", "")
  end


  private


  def file_name_valid?
    filename && File.exist?(filename)
  end

  def file_exists
    unless file_name_valid?
      errors.add(:filename, 'must exist')
    end
  end

  def delete_file
    if (file_name_valid?)
      File.delete(filename)
    end
  end
end
