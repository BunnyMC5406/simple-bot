module EmbedBuilder
  # This will build a Discord embed with neat styling
  # @param &block [Block] The block to build the embed
  # @return [Discordrb::Webhooks::Embed] The built embed
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
