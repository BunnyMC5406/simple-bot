# Ruby Discord Bot

A Discord bot developed in Ruby that enhances server management and member engagement through interactive commands and automated responses.

## Features

- Basic interaction commands (`!hello`, `!ping`) for community engagement
- Server information command (`!serverinfo`) to display server statistics and details
- Moderation capabilities (`!kick`, `!ban`) for server management
- Role management commands (`!addrole`, `!removerole`) for user role assignments
- Clear command responses with appropriate feedback messages

## Requirements

- Ruby 2.7 or higher
- Bundler gem

## Dependencies

- discordrb: Ruby implementation of the Discord API
- dotenv: Environment variable management

## Setup

1. Clone this repository
2. Install dependencies:
   ```
   gem install discordrb dotenv
   ```
3. Create a `.env` file based on `.env.example`:
   ```
   cp .env.example .env
   ```
4. Edit the `.env` file and add your Discord bot token and client ID:
   ```
   DISCORD_BOT_TOKEN=your_discord_bot_token
   DISCORD_CLIENT_ID=your_discord_client_id
   ```
5. Run the bot:
   ```
   ruby main.rb
   ```

## Available Commands

### Basic Commands
- `!hello` - Greet the bot
- `!ping` - Check bot's response time
- `!help` - Display help message with all available commands

### Server Information
- `!serverinfo` - Display detailed information about the server

### Moderation Commands
- `!kick @user [reason]` - Kick a user from the server
- `!ban @user [reason]` - Ban a user from the server

### Role Management Commands
- `!addrole @user role name` - Add a role to a user
- `!removerole @user role name` - Remove a role from a user

## Color Scheme

The bot uses Discord's standard color scheme for consistent visual feedback:
- Primary: #5865F2 (Discord blue)
- Success: #57F287 (Success green)
- Warning: #FEE75C (Warning yellow)
- Error: #ED4245 (Error red)
- Text: #FFFFFF (White)

## License

This project is open source and available under the MIT License.
