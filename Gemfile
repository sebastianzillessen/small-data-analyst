ruby '2.2.4'
# ruby 1.9.3 required, as gem `rinruby` only supports ruby 1.9.3

source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '>= 4.0.0'
# Use postgresql as the database for Active Record
gem 'pg'
# Use SCSS for stylesheets
gem 'sass-rails'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
gem 'jquery-turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', group: :doc

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

gem 'haml-rails'
gem 'puma'
gem 'foreman'
gem 'delayed_job_active_record'

gem 'ruby-graphviz'

#gem 'rack-timeout'


gem "therubyracer"
gem "less-rails" #Sprockets (what Rails 3.1 uses for its asset pipeline) supports LESS
gem "twitter-bootstrap-rails"
gem 'formtastic'
gem 'formtastic-bootstrap'
#gem 'rsruby'
gem 'rootapp-rinruby', '>= 3.1.1', :git => 'https://github.com/sebastianzillessen/rinruby.git'
gem 'devise'
gem 'cancancan'
gem 'data_migrate'
gem 'cocoon'
gem 'jquery-ui-rails'


# heroku stuff
group :production do
  gem 'rails_12factor'
  gem 'workless'
end


source 'https://rails-assets.org' do
  gem 'rails-assets-chosen'
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  gem 'rspec-rails'
  gem 'capybara'
  gem 'selenium-webdriver'
  gem 'poltergeist'
  gem 'teaspoon-jasmine'
  gem 'pry'
  gem 'factory_girl_rails'
  gem 'faker'
  gem 'shoulda-matchers'
  gem 'rspec-rerun'
end

group :test do
  gem 'capybara-screenshot'
  gem "codeclimate-test-reporter", require: nil
  gem 'database_cleaner'

end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'
  gem 'rack-mini-profiler', require: false
  gem 'bullet'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  #gem 'spring'
end

