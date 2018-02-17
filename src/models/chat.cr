struct Chat
  getter row_id : Int32
  getter id : String
  getter service : String
  getter participants : Set(User)

  def initialize(@row_id, @id, @service)
    @participants = Set(User).new
  end

  def add_participant(user)
    participants << user
  end

  def display_name
    participants.map(&.display_name).join(", ")
  end
end
