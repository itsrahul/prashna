class User < ApplicationRecord
  enum role: { user: false, admin: true }

  after_create_commit :set_verification_token, :send_verification_token
  has_secure_password

  def send_reset_link
    update(reset_token: SecureRandom.urlsafe_base64, reset_token_expire: Time.current + 2.hours)
    UserMailer.password_reset_mail(self.id).deliver_later
  end

  def activate_account(token)
    update(verification_at: Time.current) if verfication_token == token
  end

  private
    def set_verification_token
      self.update_columns(verfication_token: SecureRandom.urlsafe_base64 , verfication_token_expire: Time.current + 2.hours)
    end

    def send_verification_token
      UserMailer.verification_mail(self.id).deliver_later
    end
end
