FileDeleterJob = Struct.new(:filename) do
  def perform
    File.delete(filename)
  end
end