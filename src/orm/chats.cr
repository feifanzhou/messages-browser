module ORM
  class Chats
    getter db : DB::Database
    getter query : Queries::AllChats

    def initialize(@db, @query)
    end

    def objects
      db.query(query.sql) do |rs|
        chats = {} of String => Chat
        rs.each do
          row = rs.read(**query.read_types)
          row_id = row[:row_id]
          chat_id = row[:chat_identifier]
          service = row[:service_name]
          user_id = row[:handle_id]
          if (chat = chats[chat_id]?)
            chat.add_participant(User.new(user_id))
          else
            chat = Chat.new(row_id, chat_id, service)
            chat.add_participant(User.new(user_id))
            chats[chat_id] = chat
          end
        end
        chats.values
      end
    end
  end
end
