module Capybara::DSL
  def click_on_submit(options = {})
    if (options[:within])
      within options[:within] do
        _click_on_submit
      end
    else
      _click_on_submit
    end
  end

  private
  def _click_on_submit
    if has_selector?("input[type=submit]")
      all("input[type=submit]").last.click
    elsif has_selector?("button[type=submit]")
      all("button[type=submit]").last.click
    else
      raise "Submit button not found"
    end
  end

end

RSpec.configure do |config|
  #Capybara.javascript_driver= :selenium
  #
  #  Capybara.register_driver :selenium do |app|
  #
  #    custom_profile = Selenium::WebDriver::Firefox::Profile.new
  #
  #    # Turn off the super annoying popup!
  #    custom_profile["network.http.prompt-temp-redirect"] = false
  #
  #    Capybara::Selenium::Driver.new(app, :browser => :firefox, :profile => custom_profile)
  #  end
end

RSpec.configure do |config|
  Capybara.javascript_driver = :poltergeist
  Capybara.default_max_wait_time = 60
  Capybara.default_wait_time = 60

  Capybara.register_driver :poltergeist do |app|
    Capybara::Poltergeist::Driver.new(app,
                                      inspector: true,
                                      js_errors: true,
                                      window_size: [1100, 960],
                                      default_wait_time: 30,
                                      timeout: 90,
                                      debug: false,
                                      phantomjs_logger: true
    )
  end
end