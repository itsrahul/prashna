desc "Generate auth token to verified users without one"
task :gen_auth_token => :environment do
  User.verified.where(auth_token: nil).find_each do |user|
    user.update_columns(auth_token: SecureRandom.urlsafe_base64)
  end
end