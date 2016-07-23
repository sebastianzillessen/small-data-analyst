require "rinruby"
class RScriptExecution
  def self.execute(code, data=nil)
    r = init(code, data)
    r.pull_boolean('result')
  ensure
    r.try(:quit)
    nil
  end


  def self.retrieveFile(code, data=nil, file)
    code = "fileName <- '#{file}' \n #{code}"
    if execute(code, data)
      if (File.exist?(file))
        file
      else
        raise RuntimeError, "The R-Script ran successfully, but it did not provide an output file at the defined place 'fileName'."
      end
    else
      raise RuntimeError, "The R-Script did not set the variable 'result' to True."

    end
  end

  private
  def self.init(code, data)
    r = RinRuby.new
    if data
      filename = Rails.root.join("r_data_#{SecureRandom.hex}.csv")
      File.open(*filename, "w") do |f|
        f.write(data)
      end
      r.eval("tabular_data=read.csv(file='#{filename}')")
      File.delete(filename)
    end

    codes = code.split(/[\n\r]/).reject(&:empty?).map(&:strip)
    codes.each_with_index do |c, i|
      begin
        r.eval c
      rescue
        raise RuntimeError, "R could not evaluate the line #{i}:#{c} in your script"
      end
    end
    r
  ensure
    r
  end
end