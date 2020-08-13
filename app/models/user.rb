class User < ApplicationRecord
  include SetTopic
#done FIXME_AB:
# 1. macros
# 2. validations
# 3. associations
# 4. scopes
# 5. callbacks

  enum role: { user: 0, admin: 1 }
  enum disable_status: { enabled: 0, disabled: 1 }

  validates :name, :email, presence: true
  validates :password, presence: true, on: :create
  validates :name, length: { minimum: 3}
  validates :email, uniqueness: { case_sensitive: false }, email: true, allow_blank: true
  validates :password, length: { minimum: 4 , maximum: 80}, password: true, allow_nil: true
  validates :profile_image, image_url: true, if: Proc.new {|user| user.verified? && user.profile_image.attached? }

  has_one_attached :profile_image
  has_many :credit_transactions, dependent: :destroy
  has_many :payment_transactions, dependent: :destroy
  has_many :abuse_reports

  has_many :questions, dependent: :restrict_with_error
  has_many :answers, dependent: :restrict_with_error
  has_many :comments, dependent: :restrict_with_error
  has_many :notifications, dependent: :destroy
  has_many :votes, dependent: :restrict_with_error
  has_and_belongs_to_many :topics
  has_secure_password

  has_many :users_followed, foreign_key: "follower_id", class_name: "UserFollower"
  has_many :followed_by, foreign_key: "followed_id", class_name: "UserFollower"

  scope :verified, -> { where.not(verification_at: nil) }
  scope :unverified, -> { where(verification_at: nil) }

  before_destroy :ensure_no_purchase_history, :ensure_no_published_question
  after_create_commit :set_verification_token
  after_create_commit :send_verification_token, unless: Proc.new { |user| user.admin? }

  def send_reset_link
    update(reset_token: SecureRandom.urlsafe_base64, reset_token_expire: ENV['reset_token_validity_in_hours'].to_i.hours.after)
    UserMailer.password_reset_mail(self.id).deliver_later
  end

  def activate!
    if verification_token_expire > Time.current
      update_columns(verification_at: Time.current, auth_token: SecureRandom.urlsafe_base64)
      credit_transactions.signup.create(value: Pack.signup.credit, reason: "Signup", creditable: Pack.signup)
      clear_verification_fields
      return true
    else
      clear_verification_fields
      return false
    end
  end

  def clear_password_reset_fields
    update_columns(reset_token: nil, reset_token_expire: nil)
  end

  def clear_verification_fields
    update_columns(verification_token: nil, verification_token_expire: nil)
  end

  def verified?
    verification_at.present?
  end

  def has_sufficient_credits_to_post_question?
    credits >= ENV['credit_for_question_post'].to_i
  end

  def get_or_create_stripe_token
    if stripe_token.blank?
      # customer = StripeServices.create_customer(name, email)
      customer = Stripe::Customer.create(name: name, email: email)
      update_columns(stripe_token: customer.id)
    end
    stripe_token
  end

  private def ensure_no_purchase_history
    if credit_transactions.purchase.exists?
      errors.add(:base, I18n.t('.has_purchase_history'))
      throw :abort
    end
  end

  private def ensure_no_published_question
    if questions.published.exists?
      errors.add(:base, I18n.t('.has_published_questions'))
      throw :abort
    end
  end

  private  def set_verification_token
      self.update_columns(verification_token: SecureRandom.urlsafe_base64 , verification_token_expire: ENV['verification_token_validity_in_hours'].to_i.hours.after)
    end

  private  def send_verification_token
      UserMailer.verification_mail(self.id).deliver_later
    end
end
