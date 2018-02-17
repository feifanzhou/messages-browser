module Queries
  struct Contacts
    # Table aliases:
    #   R => ZABCDRecord
    #   P => ZABCDPHONENUMBER
    #   E => ZABCDEMAILADDRESS

    def sql
      "#{select_clause} #{from_clause};"
    end

    def read_types
      {
        email:      String?,
        phone:      String?,
        first_name: String?,
        last_name:  String?,
      }
    end

    private def fields
      %w[
        E.ZADDRESSNORMALIZED
        P.ZFULLNUMBER
        R.ZFIRSTNAME
        R.ZLASTNAME
      ]
    end

    private def select_clause
      "SELECT #{fields.join(", ")}"
    end

    private def from_clause
      "FROM ZABCDRECORD R " \
      "LEFT JOIN ZABCDPHONENUMBER P " \
      "ON P.ZOWNER = R.Z_PK " \
      "LEFT JOIN ZABCDEMAILADDRESS E " \
      "ON E.ZOWNER = R.Z_PK"
    end
  end
end
