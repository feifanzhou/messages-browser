struct Message
  getter row_id : Int32
  getter text : String
  getter time : Time
  getter sender : User

  def initialize(@row_id, @text, @time, @sender)
  end
end
