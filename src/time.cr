struct Time
  # Midnight on Jan 1, 2001
  # Seconds after UNIX epoch
  MAC_EPOCH = 978307200

  def self.from_mac_nanoseconds(timestamp : Int64)
    from_mac_seconds(timestamp // 1_000_000_000)
  end

  def self.from_mac_seconds(timestamp : Int64)
    unix(MAC_EPOCH + timestamp)
  end
end
