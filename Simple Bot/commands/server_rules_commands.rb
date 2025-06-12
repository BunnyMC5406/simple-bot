require_relative '../utils/embed_builder'

module RulesCommands
  def self.include_commands(bot)
    # !rules command
    bot.command(:rules) do |event|
      server = event.server
      
      embed = EmbedBuilder.build do |e|
        e.title = server.name
        e.description = server.description.nil? || server.description.empty? ? "No description" : server.description
        e.color = 0x5865F2
        
        e.thumbnail = { url: server.icon_url } if server.icon_url

        e.addField(name: '**Server Rules**')

        e.add_field(name: '1. No Spamming', value: 'No spamming in any chats.')
        e.add_field(name: '2. Be Respectful', value: 'Treat everyone with respect. No harassment or hate speech.')
        e.add_field(name: '3. No NSFW Content', value: 'Keep things appropriate. No adult or disturbing content.')
        e.add_field(name: '4. No Advertising', value: 'Don’t advertise other servers, links, or services.')
        e.add_field(name: '5. Use Channels Properly', value: 'Keep topics in the appropriate channels.')
        e.add_field(name: '6. No Excessive Pings', value: 'Don’t ping staff or users unnecessarily.')
        e.add_field(name: '7. Follow Staff Instructions', value: 'Staff decisions are final. Follow their guidance.')
        e.add_field(name: '8. No Exploits or Hacks', value: 'Using exploits or hacking tools is forbidden.')
        e.add_field(name: '9. Keep Usernames Appropriate', value: 'Usernames and profile pictures must follow rules.')
        e.add_field(name: '10. English Only', value: 'Please use English in public channels unless stated otherwise.')     
        
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
