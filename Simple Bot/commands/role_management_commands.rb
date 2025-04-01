require_relative '../utils/embed_builder'

module RoleManagementCommands
  def self.include_commands(bot)
    bot.command(:addrole, min_args: 2, max_args: Float::INFINITY) do |event, user_mention, *role_name|
      unless event.user.permission?(:manage_roles)
        embed = EmbedBuilder.build do |e|
          e.title = 'Permission Denied'
          e.description = 'You do not have permission to manage roles.'
          e.color = EmbedBuilder::ERROR_RED
          e.timestamp = Time.now
        end
        return event.channel.send_embed('', embed)
      end

      unless event.bot.profile.on(event.server).permission?(:manage_roles)
        embed = EmbedBuilder.build do |e|
          e.title = 'Bot Permission Error'
          e.description = 'I do not have permission to manage roles.'
          e.color = EmbedBuilder::ERROR_RED
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
          e.color = EmbedBuilder::ERROR_RED
          e.timestamp = Time.now
        end
        return event.channel.send_embed('', embed)
      end

      role_name_str = role_name.join(' ')

      role = event.server.roles.find { |r| r.name.downcase == role_name_str.downcase }
      
      if role.nil?
        embed = EmbedBuilder.build do |e|
          e.title = 'Error'
          e.description = "Could not find a role named `#{role_name_str}`. Please check the role name and try again."
          e.color = EmbedBuilder::ERROR_RED
          e.timestamp = Time.now
        end
        return event.channel.send_embed('', embed)
      end
      
      if role.position >= event.bot.profile.on(event.server).highest_role.position
        embed = EmbedBuilder.build do |e|
          e.title = 'Role Hierarchy Error'
          e.description = "I cannot assign a role that is higher than or equal to my highest role."
          e.color = EmbedBuilder::ERROR_RED
          e.timestamp = Time.now
        end
        return event.channel.send_embed('', embed)
      end

      if user.role?(role)
        embed = EmbedBuilder.build do |e|
          e.title = 'Role Already Assigned'
          e.description = "**#{user.display_name}** already has the `#{role.name}` role."
          e.color = EmbedBuilder::WARNING_YELLOW
          e.timestamp = Time.now
        end
        return event.channel.send_embed('', embed)
      end

      begin
        user.add_role(role)
        
        embed = EmbedBuilder.build do |e|
          e.title = 'Role Added'
          e.description = "Added the `#{role.name}` role to **#{user.display_name}**."
          e.color = EmbedBuilder::SUCCESS_GREEN
          e.timestamp = Time.now
          e.footer = {text: "Role added by #{event.user.display_name}"}
        end
        
        event.channel.send_embed('', embed)
      rescue Discordrb::Errors::NoPermission
        embed = EmbedBuilder.build do |e|
          e.title = 'Error'
          e.description = "I don't have permission to assign that role."
          e.color = EmbedBuilder::ERROR_RED
          e.timestamp = Time.now
        end
        event.channel.send_embed('', embed)
      rescue => e
        embed = EmbedBuilder.build do |e|
          e.title = 'Error'
          e.description = "Failed to add role: #{e.message}"
          e.color = EmbedBuilder::ERROR_RED
          e.timestamp = Time.now
        end
        event.channel.send_embed('', embed)
      end
    end

    bot.command(:removerole, min_args: 2, max_args: Float::INFINITY) do |event, user_mention, *role_name|
      unless event.user.permission?(:manage_roles)
        embed = EmbedBuilder.build do |e|
          e.title = 'Permission Denied'
          e.description = 'You do not have permission to manage roles.'
          e.color = EmbedBuilder::ERROR_RED
          e.timestamp = Time.now
        end
        return event.channel.send_embed('', embed)
      end

      unless event.bot.profile.on(event.server).permission?(:manage_roles)
        embed = EmbedBuilder.build do |e|
          e.title = 'Bot Permission Error'
          e.description = 'I do not have permission to manage roles.'
          e.color = EmbedBuilder::ERROR_RED
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
          e.color = EmbedBuilder::ERROR_RED
          e.timestamp = Time.now
        end
        return event.channel.send_embed('', embed)
      end

      role_name_str = role_name.join(' ')
      
      role = event.server.roles.find { |r| r.name.downcase == role_name_str.downcase }
      
      if role.nil?
        embed = EmbedBuilder.build do |e|
          e.title = 'Error'
          e.description = "Could not find a role named `#{role_name_str}`. Please check the role name and try again."
          e.color = EmbedBuilder::ERROR_RED
          e.timestamp = Time.now
        end
        return event.channel.send_embed('', embed)
      end
      
      if role.position >= event.bot.profile.on(event.server).highest_role.position
        embed = EmbedBuilder.build do |e|
          e.title = 'Role Hierarchy Error'
          e.description = "I cannot remove a role that is higher than or equal to my highest role."
          e.color = EmbedBuilder::ERROR_RED
          e.timestamp = Time.now
        end
        return event.channel.send_embed('', embed)
      end
      
      unless user.role?(role)
        embed = EmbedBuilder.build do |e|
          e.title = 'Role Not Assigned'
          e.description = "**#{user.display_name}** doesn't have the `#{role.name}` role."
          e.color = EmbedBuilder::WARNING_YELLOW
          e.timestamp = Time.now
        end
        return event.channel.send_embed('', embed)
      end

      begin
        user.remove_role(role)

        embed = EmbedBuilder.build do |e|
          e.title = 'Role Removed'
          e.description = "Removed the `#{role.name}` role from **#{user.display_name}**."
          e.color = EmbedBuilder::SUCCESS_GREEN
          e.timestamp = Time.now
          e.footer = {text: "Role removed by #{event.user.display_name}"}
        end
        
        event.channel.send_embed('', embed)
      rescue Discordrb::Errors::NoPermission
        embed = EmbedBuilder.build do |e|
          e.title = 'Error'
          e.description = "I don't have permission to remove that role."
          e.color = EmbedBuilder::ERROR_RED
          e.timestamp = Time.now
        end
        event.channel.send_embed('', embed)
      rescue => e
        embed = EmbedBuilder.build do |e|
          e.title = 'Error'
          e.description = "Failed to remove role: #{e.message}"
          e.color = EmbedBuilder::ERROR_RED
          e.timestamp = Time.now
        end
        event.channel.send_embed('', embed)
      end
    end
  end
end