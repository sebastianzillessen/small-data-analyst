class Array
  # is this a strict subset of the other array
  def subset?(b)
    return false if b.eql?(self)
    self.subseteq?(b)
  end

  # is this a subset of the other array or the same?
  def subseteq?(b)
    (b & self) == self
  end
end