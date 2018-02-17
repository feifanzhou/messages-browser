module Queries
  struct ChatMessages
    # Table aliases:
    #   M => message
    #   CMJ => chat_message_join
    #   H => handle
    #   MAJ => message_attachment_join
    #   A => attachment

    def sql
      "#{select_clause} #{from_clause} #{order_by_clause};"
    end

    def read_types
      {
        row_id:    Int32,
        text:      String,
        handle_id: String,
        date:      Int64,
        from_me:   Bool,
        name:      String?,
        path:      String?,
        bytes:     Int32?,
      }
    end

    private def fields
      %w[
        M.ROWID
        M.text
        H.id
        M.date
        M.is_from_me
        A.transfer_name
        A.filename
        A.total_bytes
      ]
    end

    private def select_clause
      "SELECT #{fields.join(", ")}"
    end

    private def from_clause
      "FROM message M " \
      "JOIN chat_message_join CMJ " \
      "ON CMJ.chat_id=? AND M.ROWID=CMJ.message_id " \
      "JOIN handle H ON M.handle_id = H.ROWID " \
      "LEFT JOIN message_attachment_join MAJ ON MAJ.message_id  = M.ROWID " \
      "LEFT JOIN attachment A ON MAJ.attachment_id = A.ROWID"
    end

    private def order_by_clause
      "ORDER BY M.date"
    end
  end
end
