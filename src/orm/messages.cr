module ORM
  class Messages
    getter db : DB::Database
    getter query : Queries::ChatMessages

    def initialize(@db, @query)
    end

    def objects(chat_row_id : Int32)
      db.query(query.sql, chat_row_id) do |rs|
        messages = [] of Message
        rs.each do
          row = rs.read(**query.read_types)
          row_id = row[:row_id]
          text = row[:text]
          user_id = row[:handle_id]
          timestamp = row[:date]
          messages << Message.new(
            row_id,
            text,
            Time.from_mac_nanoseconds(timestamp),
            User.new(user_id)
          )
        end
        messages
      end
    end
  end
end
