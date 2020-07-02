class User < ApplicationRecord
  enum role: { user: 0, admin: 1 }

  has_secure_password

  validates :name, presence: true
  #FIXME_AB: email format
  validates :email, uniqueness: { case_sensitive: false }#, email: true


  scope :verified, -> { where.not(verification_at: nil) }
  scope :unverified, -> { where(verification_at: nil) }

  after_create_commit :set_verification_token, :send_verification_token

  def send_reset_link
    update(reset_token: SecureRandom.urlsafe_base64, reset_token_expire: ENV['reset_token_valid'].to_i.hours.after)
    UserMailer.password_reset_mail(self.id).deliver_later
  end

  def activate!
    update_columns(verification_token: nil, verification_token_expire: nil)
    if verification_token_expire > Time.current
      update(verification_at: Time.current)
      return true
    else
      return false
    end

  end

  private  def set_verification_token
      self.update_columns(verification_token: SecureRandom.urlsafe_base64 , verification_token_expire: ENV['verification_token_valid'].to_i.hours.after)
    end

  private  def send_verification_token
      UserMailer.verification_mail(self.id).deliver_later
    end
end
