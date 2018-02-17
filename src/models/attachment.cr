struct Attachment
  getter name : String
  getter file_path : String
  getter bytes : Int32

  def initialize(@name, @file_path, @bytes)
  end
end
