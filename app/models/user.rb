class User < ActiveRecord::Base
  ROLES = {admin: 'admin', statistician: 'statistician', clinician: 'clinician'}

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  scope :admins, -> { where(role: 'admin') }

  has_many :assumptions
  has_many :research_questions
  has_many :analyses, dependent: :destroy
  has_many :models
  has_many :datasets, dependent: :destroy
  has_many :preferences, dependent: :destroy


  after_create :send_admin_mail
  validates :role, inclusion: {in: ROLES.map { |k, v| v }}, allow_nil: true, allow_blank: true


  def is_admin?
    role.try(:to_sym)== :admin
  end

  def is_statistician?
    is_admin? || role.try(:to_sym)== :statistician
  end

  def is_clinician?
    is_statistician? || role.try(:to_sym)== :clinician
  end

  def active_for_authentication?
    super && approved?
  end


  def inactive_message
    if !approved?
      :not_approved
    else
      super # Use whatever other message
    end
  end

  # confirm
  def password_required?
    super if confirmed?
  end

  def password_match?
    self.errors[:password] << "can't be blank" if password.blank?
    self.errors[:password_confirmation] << "can't be blank" if password_confirmation.blank?
    self.errors[:password_confirmation] << "does not match password" if password != password_confirmation
    password == password_confirmation && !password.blank?
  end


  def self.send_reset_password_instructions(attributes={})
    recoverable = find_or_initialize_with_errors(reset_password_keys, attributes, :not_found)
    if !recoverable.approved?
      recoverable.errors[:base] << I18n.t("devise.failure.not_approved")
    elsif recoverable.persisted?
      recoverable.send_reset_password_instructions
    end
    recoverable
  end

  def send_admin_mail
    AdminMailer.new_user_waiting_for_approval(self).deliver_later unless (approved)
  end
end

