class Array
  # is this a strict subset of the other array
  def subset?(b)
    return false if b.uniq.sort == self.uniq.sort
    self.subseteq?(b)
  end

  # is this a subset of the other array or the same?
  def subseteq?(b)
    (b & self).uniq.sort == self.uniq.sort
  end
end