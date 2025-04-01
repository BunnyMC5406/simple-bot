require_relative '../utils/embed_builder'

module ModerationCommands
  def self.include_commands(bot)
    bot.command(:kick, min_args: 1, max_args: Float::INFINITY) do |event, user_mention, *reason|
      unless event.user.permission?(:kick_members)
        embed = EmbedBuilder.build do |e|
          e.title = 'Permission Denied'
          e.description = 'You do not have permission to kick members.'
          e.color = 0xED4245
          e.timestamp = Time.now
        end
        return event.channel.send_embed('', embed)
      end

      user_id = user_mention.gsub(/<@!?(\d+)>/, '\1').to_i
      user = event.server.member(user_id)

      if user.nil?
        embed = EmbedBuilder.build do |e|
          e.title = 'Error'
          e.description = 'Could not find that user. Please provide a valid user mention.'
          e.color = 0xED4245 # Error red
          e.timestamp = Time.now
        end
        return event.channel.send_embed('', embed)
      end

      unless event.bot.profile.on(event.server).permission?(:kick_members)
        embed = EmbedBuilder.build do |e|
          e.title = 'Bot Permission Error'
          e.description = 'I do not have permission to kick members.'
          e.color = 0xED4245 # Error red
          e.timestamp = Time.now
        end
        return event.channel.send_embed('', embed)
      end

      if user.highest_role.position >= event.bot.profile.on(event.server).highest_role.position
        embed = EmbedBuilder.build do |e|
          e.title = 'Role Hierarchy Error'
          e.description = "I cannot kick users with a higher or equal role to mine."
          e.color = 0xED4245 # Error red
          e.timestamp = Time.now
        end
        return event.channel.send_embed('', embed)
      end

      reason_str = reason.empty? ? 'No reason provided' : reason.join(' ')

      begin
        event.server.kick(user, reason_str)
        embed = EmbedBuilder.build do |e|
          e.title = 'User Kicked'
          e.description = "**#{user.display_name}** has been kicked from the server."
          e.add_field(name: 'Reason', value: reason_str)
          e.color = 0xFEE75C # Warning yellow
          e.timestamp = Time.now
          e.footer = {text: "Kicked by #{event.user.display_name}"}
        end
        
        event.channel.send_embed('', embed)
      rescue Discordrb::Errors::NoPermission
        embed = EmbedBuilder.build do |e|
          e.title = 'Error'
          e.description = 'I do not have permission to kick that user.'
          e.color = 0xED4245
          e.timestamp = Time.now
        end
        event.channel.send_embed('', embed)
      rescue => e
        embed = EmbedBuilder.build do |e|
          e.title = 'Error'
          e.description = "Failed to kick user: #{e.message}"
          e.color = 0xED4245
          e.timestamp = Time.now
        end
        event.channel.send_embed('', embed)
      end
    end

    # !ban command
    bot.command(:ban, min_args: 1, max_args: Float::INFINITY) do |event, user_mention, *reason|
      unless event.user.permission?(:ban_members)
        embed = EmbedBuilder.build do |e|
          e.title = 'Permission Denied'
          e.description = 'You do not have permission to ban members.'
          e.color = 0xED4245
          e.timestamp = Time.now
        end
        return event.channel.send_embed('', embed)
      end

      user_id = user_mention.gsub(/<@!?(\d+)>/, '\1').to_i
      user = event.server.member(user_id)

      if user.nil?
        embed = EmbedBuilder.build do |e|
          e.title = 'Error'
          e.description = 'Could not find that user. Please provide a valid user mention.'
          e.color = 0xED4245 # Error red
          e.timestamp = Time.now
        end
        return event.channel.send_embed('', embed)
      end

      unless event.bot.profile.on(event.server).permission?(:ban_members)
        embed = EmbedBuilder.build do |e|
          e.title = 'Bot Permission Error'
          e.description = 'I do not have permission to ban members.'
          e.color = 0xED4245 # Error red
          e.timestamp = Time.now
        end
        return event.channel.send_embed('', embed)
      end
      
      if user.highest_role.position >= event.bot.profile.on(event.server).highest_role.position
        embed = EmbedBuilder.build do |e|
          e.title = 'Role Hierarchy Error'
          e.description = "I cannot ban users with a higher or equal role to mine."
          e.color = 0xED4245 # Error red
          e.timestamp = Time.now
        end
        return event.channel.send_embed('', embed)
      end

      reason_str = reason.empty? ? 'No reason provided' : reason.join(' ')

      begin
        event.server.ban(user, 0, reason: reason_str)
        
        embed = EmbedBuilder.build do |e|
          e.title = 'User Banned'
          e.description = "**#{user.display_name}** has been banned from the server."
          e.add_field(name: 'Reason', value: reason_str)
          e.color = 0xED4245
          e.timestamp = Time.now
          e.footer = {text: "Banned by #{event.user.display_name}"}
        end
        
        event.channel.send_embed('', embed)
      rescue Discordrb::Errors::NoPermission
        embed = EmbedBuilder.build do |e|
          e.title = 'Error'
          e.description = 'I do not have permission to ban that user.'
          e.color = 0xED4245
          e.timestamp = Time.now
        end
        event.channel.send_embed('', embed)
      rescue => e
        embed = EmbedBuilder.build do |e|
          e.title = 'Error'
          e.description = "Failed to ban user: #{e.message}"
          e.color = 0xED4245
          e.timestamp = Time.now
        end
        event.channel.send_embed('', embed)
      end
    end
  end
end
