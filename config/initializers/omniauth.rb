OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, ENV['FACEBOOK_APP_ID'], ENV['FACEBOOK_APP_SECRET'],
           :scope                  => ENV['FACEBOOK_SCOPE'],
           :provider_ignores_state => true,
           :secure_image_url       => true
end
