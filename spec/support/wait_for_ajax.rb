# spec/support/wait_for_ajax.rb
module WaitForAjax
  def wait_for_ajax(counter=10)
    puts "wait_for_ajax: #{counter}"
    Timeout.timeout(Capybara.default_max_wait_time) do
      loop until finished_all_ajax_requests?
    end
  rescue Timeout::Error => e
    if counter > 0
      wait_for_ajax(counter-1)
    else
      raise e
    end
  end

  def finished_all_ajax_requests?
    page.evaluate_script('$.active').tap { |x| puts x }.zero?
  end
end

RSpec.configure do |config|
  config.include WaitForAjax, type: :feature
end