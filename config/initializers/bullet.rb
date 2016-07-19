Rails.application.configure do
  if Rails.env.development?
    puts "Init Bullet"
    config.after_initialize do
      Bullet.enable = true
      #Bullet.alert = true
      Bullet.bullet_logger = true
      Bullet.console = true
    end
  end
end