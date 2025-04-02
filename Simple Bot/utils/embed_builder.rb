module EmbedBuilder
  def self.build(&block)
    embed = Discordrb::Webhooks::Embed.new

    embed.timestamp = Time.now
    
    yield embed if block_given?
    
    embed
  end
  
  DISCORD_BLUE = 0x5865F2
  SUCCESS_GREEN = 0x57F287
  WARNING_YELLOW = 0xFEE75C
  ERROR_RED = 0xED4245
  WHITE = 0xFFFFFF
end
