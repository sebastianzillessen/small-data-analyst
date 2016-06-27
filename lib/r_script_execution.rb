require "rinruby"
class RScriptExecution
  def self.execute(code, data=nil)
    r = RinRuby.new
    if data
      r.assign "data", data
      # make data to list according to csv.
      r.eval("tabular_data=read.csv(textConnection(data))")
    end
    puts "Evaluating #{code}"
    r.eval code
    result = r.pull_boolean('result')
    return result
  ensure
    r.quit
  end
end