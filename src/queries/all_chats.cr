module Queries
  struct AllChats
    # Table aliases:
    #   C => chat
    #   CHJ => chat_handle_join
    #   H => handle

    def sql
      "#{select_clause} #{from_clause};"
    end

    def read_types
      {
        row_id:          Int32,
        chat_identifier: String,
        service_name:    String,
        handle_id:       String,
      }
    end

    private def fields
      %w[
        C.ROWID
        C.chat_identifier
        C.service_name
        H.id
      ]
    end

    private def select_clause
      "SELECT #{fields.join(", ")}"
    end

    private def from_clause
      "FROM chat C " \
      "JOIN chat_handle_join CHJ ON C.ROWID = CHJ.chat_id " \
      "JOIN handle H ON CHJ.handle_id = H.ROWID"
    end
  end
end
