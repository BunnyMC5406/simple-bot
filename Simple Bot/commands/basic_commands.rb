require_relative '../utils/embed_builder'

module BasicCommands
  def self.include_commands(bot)
    bot.command(:hello) do |event|
      username = event.user.display_name

      embed = EmbedBuilder.build do |e|
        e.title = 'Hello!'
        e.description = "Hello there, #{username}! How are you doing today?"
        e.color = 0x5865F2
        e.timestamp = Time.now
      end

      event.channel.send_embed('', embed)
    end

    bot.command(:ping) do |event|
      start_time = Time.now
      message = event.respond('Calculating ping...')
      end_time = Time.now
      latency = ((end_time - start_time) * 1000).round

      embed = EmbedBuilder.build do |e|
        e.title = 'Pong!'
        e.description = "Latency: #{latency}ms\nAPI Latency: #{bot.latency}ms"
        e.color = 0x57F287
        e.timestamp = Time.now
      end

      message.edit('', embed)
    end

    bot.command(:help) do |event|
      embed = EmbedBuilder.build do |e|
        e.title = 'Bot Commands'
        e.description = 'Here are the available commands:'
        e.color = 0x5865F2

    bot.command(:info) do |event|
      embed = EmbedBuilder.build do |e|
        e.title = 'Info'
        e.description = 'Our server description here.'
        e.color = 0x4537F8
        
        e.add_field(name: 'Basic Commands', value: <<~COMMANDS, inline: false)
          `!hello` - Greet the bot
          `!ping` - Check bot's response time
          `!help` - Display this help message
          `!info` - Get info about our server
        COMMANDS
        
        e.add_field(name: 'Server Information', value: <<~COMMANDS, inline: false)
          `!serverinfo` - Display information about the server
        COMMANDS
        
        e.add_field(name: 'Moderation Commands', value: <<~COMMANDS, inline: false)
          `!kick @user [reason]` - Kick a user from the server
          `!ban @user [reason]` - Ban a user from the server
        COMMANDS
        
        e.add_field(name: 'Role Management', value: <<~COMMANDS, inline: false)
          `!addrole @user role name` - Add a role to a user
          `!removerole @user role name` - Remove a role from a user
        COMMANDS
        
        e.timestamp = Time.now
        e.footer = {text: 'Use ! prefix before each command'}
      end

      event.channel.send_embed('', embed)
    end
  end
end
