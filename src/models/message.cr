struct Message
  getter row_id : Int32
  getter text : String
  getter time : Time
  getter sender : User
  getter from_me : Bool
  property attachments : Array(Attachment)

  def initialize(@row_id, @text, @time, @sender, @from_me, @attachments)
  end

  def local_time
    time.to_local
  end

  def mine?
    from_me
  end

  def has_attachments?
    attachments.size > 0
  end
end
