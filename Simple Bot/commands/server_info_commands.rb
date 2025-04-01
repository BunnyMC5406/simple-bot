require_relative '../utils/embed_builder'

module ServerInfoCommands
  def self.include_commands(bot)
    # !serverinfo command
    bot.command(:serverinfo) do |event|
      server = event.server
      
      online_members = server.members.count { |member| member.status != :offline }
      
      creation_time = server.creation_time.strftime('%B %d, %Y')
      
      text_channels = server.text_channels.size
      voice_channels = server.voice_channels.size
      
      region = server.region

      embed = EmbedBuilder.build do |e|
        e.title = server.name
        e.description = server.description.nil? || server.description.empty? ? "No description" : server.description
        e.color = 0x5865F2
        
        e.thumbnail = { url: server.icon_url } if server.icon_url

        e.add_field(name: 'Owner', value: "<@#{server.owner.id}>", inline: true)
        e.add_field(name: 'Server ID', value: server.id, inline: true)
        e.add_field(name: 'Created On', value: creation_time, inline: true)

        e.add_field(name: 'Members', value: "Total: #{server.member_count}\nOnline: #{online_members}", inline: true)

        e.add_field(name: 'Channels', value: "Text: #{text_channels}\nVoice: #{voice_channels}", inline: true)
        
        e.add_field(name: 'Roles', value: server.roles.size, inline: true)

        e.add_field(name: 'Region', value: region.to_s, inline: true)
        e.add_field(name: 'Verification Level', value: server.verification_level.to_s.capitalize, inline: true)
        
        if server.respond_to?(:premium_tier)
          e.add_field(name: 'Boost Tier', value: server.premium_tier, inline: true)
          e.add_field(name: 'Boosts', value: server.respond_to?(:premium_subscription_count) ? server.premium_subscription_count : 'Unknown', inline: true)
        end
        
        e.timestamp = Time.now
        e.footer = { text: "Requested by #{event.user.display_name}" }
      end
      
      event.channel.send_embed('', embed)
    end
  end
end
