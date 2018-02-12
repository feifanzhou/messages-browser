struct User
  getter id : String

  def initialize(@id)
  end

  def ==(other)
    other.id == self.id
  end
end
