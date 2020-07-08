class User < ApplicationRecord

#FIXME_AB:
# 1. macros
# 2. validations
# 3. associations
# 4. scopes
# 5. callbacks

  enum role: { user: 0, admin: 1 }

  has_one_attached :profile_image

  has_many :credit_transactions, dependent: :destroy
  has_many :questions
  has_and_belongs_to_many :topics

  has_secure_password

  validates :name, :email, presence: true
  validates :name, length: { minimum: 3}
  validates :email, uniqueness: { case_sensitive: false }, email: true, allow_blank: true
  validates :password, length: { minimum: 4 , maximum: 80}, password: true, allow_blank: true
  validates :profile_image_url, image_url: true, if: Proc.new {|user| user.verified? }


  scope :verified, -> { where.not(verification_at: nil) }
  scope :unverified, -> { where(verification_at: nil) }

  before_destroy :ensure_no_purchase_history
  after_create_commit :set_verification_token
  after_create_commit :send_verification_token, unless: Proc.new { |user| user.admin? }

  def send_reset_link
    update(reset_token: SecureRandom.urlsafe_base64, reset_token_expire: ENV['reset_token_valid'].to_i.hours.after)
    UserMailer.password_reset_mail(self.id).deliver_later
  end

  def activate!
    if verification_token_expire > Time.current
      update(verification_at: Time.current)
      credit_transactions.signup.create(value: ENV['signup_credits'], reason: "Signup")
      clear_verification_reset_fields
      return true
    else
      clear_verification_reset_fields
      return false
    end
  end

  def clear_password_reset_fields
    update_columns(reset_token: nil, reset_token_expire: nil)
  end

  def clear_verification_reset_fields
    update_columns(verification_token: nil, verification_token_expire: nil)
  end

  def verified?
    #FIXME_AB: verification_at.present?
    !verification_at.nil?
  end

  private def ensure_no_purchase_history
    if credit_transactions.purchase.exists?
      errors.add(:base, 'User has purchased credits')
      throw :abort
    end
  end

  private def profile_image_url
    #FIXME_AB: profile_image.attachment.image? can be used to check if attachment is image or not
    profile_image.attachment.blob.filename.to_s
  end

  private  def set_verification_token
      self.update_columns(verification_token: SecureRandom.urlsafe_base64 , verification_token_expire: ENV['verification_token_valid'].to_i.hours.after)
    end

  private  def send_verification_token
      UserMailer.verification_mail(self.id).deliver_later
    end
end
