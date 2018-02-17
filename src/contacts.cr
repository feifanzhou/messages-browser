require "db"
require "file_utils"
require "sqlite3"

class Contacts
  getter email_index : Hash(String, String)
  getter phone_index : Hash(String, String)

  NORMALIZE_PHONE_REGEX = /\D/

  def initialize
    db_paths = copy_dbs!
    query = Queries::Contacts.new
    emails = {} of String => Array(String)
    phones = {} of String => Array(String)
    db_paths.each do |db_path|
      DB.open("sqlite3://#{db_path}") do |db|
        db.query(query.sql) do |rs|
          rs.each do
            row = rs.read(**query.read_types)
            email = row[:email]
            phone = row[:phone]
            first_name = row[:first_name]
            last_name = row[:last_name]
            name_key = "#{first_name} #{last_name}"
            if email && !email.blank?
              if (r = emails[name_key]?)
                r << email
              else
                emails[name_key] = [email]
              end
            end
            if phone && !phone.blank?
              normalized_phone = phone.gsub(NORMALIZE_PHONE_REGEX, "")
              if (r = phones[name_key]?)
                r << normalized_phone
              else
                phones[name_key] = [normalized_phone]
              end
            end
          end
        end
      end
    end
    @email_index = {} of String => String
    emails.each do |name, emails|
      emails.each { |email| @email_index[email] = name }
    end
    @phone_index = {} of String => String
    phones.each do |name, phones|
      phones.each { |phone| @phone_index[phone] = name }
    end
  end

  def name_from_email(name)
    email_index[name]?
  end

  def name_from_phone(phone)
    search_phone = phone.gsub(NORMALIZE_PHONE_REGEX, "")
    return nil if search_phone.blank?
    if result = phone_index[search_phone]?
      result
    else
      start_index = search_phone.size - 10
      return nil if start_index < 1
      phone_without_country = search_phone[start_index, 10]
      phone_index[phone_without_country]?
    end
  end

  private def sources_path
    raise "Could not determine HOME directory" unless ENV.has_key?("HOME")
    "#{ENV["HOME"]}/Library/Application Support/AddressBook/Sources"
  end

  private def source_database_paths
    Dir.children(sources_path).map do |source_uuid|
      "#{sources_path}/#{source_uuid}/AddressBook-v22.abcddb"
    end
  end

  private def copy_dbs!
    db_paths = source_database_paths
    db_paths.each_with_index do |original_path, index|
      destination_path = "/tmp/contacts-#{Process.pid}-#{index}.db"
      raise "#{original_path} does not exist" unless File.exists?(original_path)
      raise "#{original_path} is not a file" unless File.file?(original_path)
      FileUtils.cp(original_path, destination_path)
    end
    db_paths
  end
end
