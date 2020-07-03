class User < ApplicationRecord
  enum role: { user: 0, admin: 1 }
  has_one_attached :profile_image
  has_many :credit_transactions, dependent: :destroy

  has_secure_password

  validates :name, :email, presence: true
  #FIXME_AB: email format
  validates :name, length: { minimum: 3}
  validates :email, uniqueness: { case_sensitive: false }, email: true, allow_blank: true
  validates :password, length: { minimum: 4 , maximum: 8}, password: true, allow_blank: true


  scope :verified, -> { where.not(verification_at: nil) }
  scope :unverified, -> { where(verification_at: nil) }

  after_create_commit :set_verification_token 
  after_create_commit :send_verification_token, unless: Proc.new { |user| user.admin? }
  has_secure_password

  def send_reset_link
    update(reset_token: SecureRandom.urlsafe_base64, reset_token_expire: ENV['reset_token_valid'].to_i.hours.after)
    UserMailer.password_reset_mail(self.id).deliver_later
  end

  def activate!
    if verification_token_expire > Time.current
      update(verification_at: Time.current)
      credit_transactions.create(value: ENV['signup_credits'], reason: "Signup")
      clear_verification_reset_fields and return true
    else
      clear_verification_reset_fields and return false
    end
  end

  def clear_password_reset_fields
    update_columns(reset_token: nil, reset_token_expire: nil)
  end

  def clear_verification_reset_fields
    update_columns(verification_token: nil, verification_token_expire: nil)
  end

  private  def set_verification_token
      self.update_columns(verification_token: SecureRandom.urlsafe_base64 , verification_token_expire: ENV['verification_token_valid'].to_i.hours.after)
    end

  private  def send_verification_token
      UserMailer.verification_mail(self.id).deliver_later
    end
end
