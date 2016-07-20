require "rinruby"
class RScriptExecution
  def self.execute(code, data=nil)
    r = RinRuby.new
    if data
      r.assign "data", data
      # make data to list according to csv.
      r.eval("tabular_data=read.csv(textConnection(data))")
    end
    r.eval code

    result = begin
      r.pull_boolean('result')
    rescue
      r.pull('fileResult')
    end
    return result
  ensure
    r.quit
  end
end