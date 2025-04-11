# ------>
#
# BOT MADE BY: BUNNYMC5406
#
# ------>
require 'discordrb'
require 'dotenv'
require_relative 'commands/basic_commands'
require_relative 'commands/moderation_commands'
require_relative 'commands/server_info_commands'
require_relative 'commands/role_management_commands'

Dotenv.load

BOT_TOKEN = ENV['DISCORD_BOT_TOKEN']
CLIENT_ID = ENV['DISCORD_CLIENT_ID']

if BOT_TOKEN.nil? || BOT_TOKEN.empty?
  puts 'Error: DISCORD_BOT_TOKEN environment variable is not set.'
  puts 'Please create a .env file with your bot token or set the environment variable.'
  exit(1)
end

if CLIENT_ID.nil? || CLIENT_ID.empty?
  puts 'Error: DISCORD_CLIENT_ID environment variable is not set.'
  puts 'Please create a .env file with your client ID or set the environment variable.'
  exit(1)
end

bot = Discordrb::Commands::CommandBot.new(
  token: BOT_TOKEN,
  client_id: CLIENT_ID,
  prefix: '!'
)

BasicCommands.include_commands(bot)
ModerationCommands.include_commands(bot)
ServerInfoCommands.include_commands(bot)
RoleManagementCommands.include_commands(bot)

bot.ready do |event|
  puts "Bot connected to Discord as #{bot.profile.username}##{bot.profile.discriminator}"
  puts "Bot is in #{bot.servers.size} servers"
  bot.game = "!help for commands"
end

puts 'Starting Discord bot...'
bot.run
