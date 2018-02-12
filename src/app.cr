require "kemal"
require "./*"

print "Starting…\n"
print "Opening database…\r"
db = Database.new
print "\e[KDatabase ready\n"

get "/" do
  chats = db.all_chats
  render "src/views/index.ecr", "src/views/layout.ecr"
end

get "/chat/:chat_id" do |env|
  chats = db.all_chats
  chat_id = env.params.url["chat_id"].try(&.to_i)
  messages = db.chat_messages(chat_id)
  render "src/views/messages.ecr", "src/views/layout.ecr"
end

Kemal.run
