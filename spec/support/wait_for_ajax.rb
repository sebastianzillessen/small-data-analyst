# spec/support/wait_for_ajax.rb
module WaitForAjax
  def wait_for_ajax()
    Timeout.timeout(Capybara.default_max_wait_time/10) do
      loop until finished_all_ajax_requests?
    end
  end

  def finished_all_ajax_requests?
    page.evaluate_script('$.active').zero?
  end
end

RSpec.configure do |config|
  config.include WaitForAjax, type: :feature
end