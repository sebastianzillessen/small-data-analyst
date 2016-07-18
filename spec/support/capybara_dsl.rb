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


Capybara.register_driver :poltergeist do |app|
  Capybara.default_max_wait_time = 10
  driver = Capybara::Poltergeist::Driver.new(app, debug: false, window_size: [1100, 960], timeout: 60)
  driver
end