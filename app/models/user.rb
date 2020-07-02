class User < ApplicationRecord
  enum role: { user: 0, admin: 1 }

  #FIXME_AB: add unique index on email, verfication_token, reset_token
  #FIXME_AB: make a scope `verified` so that we can use User.verified
  #FIXME_AB: similarly verified

  #FIXME_AB: add validations
  validates :name, presence: true
  validates :email, uniqueness: { case_sensitive: false }#, email: true


  scope :verified, -> { where.not(verification_at: nil) }
  scope :unverified, -> { where(verification_at: nil) }

  after_create_commit :set_verification_token, :send_verification_token
  has_secure_password

  def send_reset_link
    update(reset_token: SecureRandom.urlsafe_base64, reset_token_expire: ENV['reset_token_valid'].to_i.hours.after)
    UserMailer.password_reset_mail(self.id).deliver_later
  end

  #FIXME_AB: activate!
  def activate!
    #FIXME_AB: check expiry according do the action
    #FIXME_AB: in any case, invalid or valid. clear token and expires at
    update_columns(verification_token: nil, verification_token_expire: nil)
    if verification_token_expire > Time.current
      update(verification_at: Time.current)
      return true
    else
      return false
    end

  end

  private  def set_verification_token
      #FIXME_AB: use figaro. 2.hours.after, 2.hours.from_now
      self.update_columns(verification_token: SecureRandom.urlsafe_base64 , verification_token_expire: ENV['verification_token_valid'].to_i.hours.after)
    end

  private  def send_verification_token
      UserMailer.verification_mail(self.id).deliver_later
    end
end
