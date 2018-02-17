module ORM
  class Messages
    getter db : DB::Database
    getter query : Queries::ChatMessages

    def initialize(@db, @query)
    end

    def objects(chat_row_id : Int32)
      db.query(query.sql, chat_row_id) do |rs|
        messages = {} of Int32 => Message
        rs.each do
          row = rs.read(**query.read_types)
          row_id = row[:row_id]
          text = row[:text]
          user_id = row[:handle_id]
          timestamp = row[:date]
          from_me = row[:from_me]
          attachment_name = row[:name]
          attachment_path = row[:path]
          attachment_bytes = row[:bytes]
          if attachment_name && attachment_path && attachment_bytes
            attachment = Attachment.new(
              attachment_name,
              attachment_path,
              attachment_bytes
            )
          else
            attachment = nil
          end
          if messages[row_id]?.nil?
            messages[row_id] = Message.new(
              row_id,
              text,
              Time.from_mac_nanoseconds(timestamp),
              User.new(user_id),
              from_me,
              attachment ? [attachment] : [] of Attachment
            )
          elsif attachment
            messages[row_id].attachments << attachment
          end
        end
        messages.values
      end
    end
  end
end
