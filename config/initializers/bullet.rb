Rails.application.configure do
  if Rails.env.development?
    puts "Init Bullet"
    config.after_initialize do
      Bullet.enable = true
      #Bullet.alert = true
      Bullet.bullet_logger = true
      Bullet.console = true
      Bullet.growl = false

      Bullet.rails_logger = true
      Bullet.honeybadger = false
      Bullet.bugsnag = false
      Bullet.airbrake = false
      Bullet.rollbar = false
      Bullet.add_footer = true
    end
  end
end