struct Message
  getter row_id : Int32
  getter text : String
  getter time : Time
  getter sender : User
  getter from_me : Bool

  def initialize(@row_id, @text, @time, @sender, @from_me)
  end

  def local_time
    time.to_local
  end

  def mine?
    from_me
  end
end
