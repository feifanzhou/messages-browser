struct MessagePresenter
  getter message : Message

  def initialize(@message)
  end

  def display_html
    if message.has_attachments?
      attachments_html
    else
      HTML.escape(message.text)
    end
  end

  private def attachments_html
    message.attachments.map do |attachment|
      "<a class='message-attachment' target='_blank' " \
      "href=#{href_for_attachment(attachment)}>" \
      "#{attachment.name} (#{attachment.bytes} bytes)" \
      "</a>"
    end.join
  end

  private def href_for_attachment(attachment)
    path = attachment.file_path
                     .gsub("~", ENV["HOME"])
                     .gsub(" ", "%20")
    "file://#{path}"
  end
end
