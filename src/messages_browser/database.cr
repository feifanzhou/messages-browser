require "db"
require "file_utils"
require "sqlite3"

class Database
  getter db_path : String
  getter db : DB::Database

  def initialize
    @db_path = copy_db
    @db = DB.open("sqlite3://#{@db_path}")
  end

  def all_chats
    query = Queries::AllChats.new
    ORM::Chats.new(db, query).objects
  end

  def finalize
    db_cleanup
  end

  private def original_db_path
    raise "Could not determine HOME directory" unless ENV.has_key?("HOME")
    "#{ENV["HOME"]}/Library/Messages/chat.db"
  end

  private def copied_db_path
    "/tmp/chat-#{Process.pid}.db"
  end

  private def copy_db
    original_path = original_db_path
    destination_path = copied_db_path
    raise "#{original_path} does not exist" unless File.exists?(original_path)
    raise "#{original_path} is not a file" unless File.file?(original_path)
    FileUtils.cp(original_path, destination_path)
    destination_path
  end

  private def db_cleanup
    db.close
  end
end
