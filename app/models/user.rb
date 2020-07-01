class User < ApplicationRecord
  enum role: { user: false, admin: true }

  #FIXME_AB: add unique index on email, verfication_token, reset_token

  #FIXME_AB: add validations

  #FIXME_AB: make a scope `verified` so that we can use User.verified
  #FIXME_AB: similarly unverified

  after_create_commit :set_verification_token, :send_verification_token
  has_secure_password

  def send_reset_link
    update(reset_token: SecureRandom.urlsafe_base64, reset_token_expire: Time.current + 2.hours)
    UserMailer.password_reset_mail(self.id).deliver_later
  end

  #FIXME_AB: activate!
  def activate_account(token)
    #FIXME_AB: check expiry according do the action
    #FIXME_AB: in any case, invalid or valid. clear token and expires at
    update(verification_at: Time.current) if verfication_token == token
  end

  private  def set_verification_token
      #FIXME_AB: use figaro. 2.hours.after, 2.hours.from_now
      self.update_columns(verfication_token: SecureRandom.urlsafe_base64 , verfication_token_expire: Time.current + 2.hours)
    end

  private  def send_verification_token
      UserMailer.verification_mail(self.id).deliver_later
    end
end
