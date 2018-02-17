struct User
  @@contacts = Contacts.new

  getter id : String

  def initialize(@id)
  end

  def ==(other)
    other.id == self.id
  end

  def display_name
    @@contacts.name_from_email(id) ||
      @@contacts.name_from_phone(id) ||
      id
  end
end
