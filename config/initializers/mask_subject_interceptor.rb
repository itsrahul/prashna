class MaskSubjectInterceptor
  def self.delivering_email(message)
    message.subject = "[#{Rails.env}] #{message.subject}"
  end
end

if not Rails.env.production?
  ActionMailer::Base.register_interceptor(MaskSubjectInterceptor)
end