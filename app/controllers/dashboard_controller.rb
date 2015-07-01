class DashboardController < ApplicationController
  def commands
    user_level = params[:user_level]
    all = params[:all]
    @channel = params[:channel]
    case user_level
      when 'all'
        get_commands(%w(DEFAULT SUBSCRIBER REGULAR MODERATOR SUPER_MODERATOR BROADCASTER INTERNAL))
      when 'usr'
        get_commands('DEFAULT')
      when 'sub'
        if !all.nil? && all == 'all'
          get_commands(%w(SUBSCRIBER DEFAULT))
        else
          get_commands(%w(SUBSCRIBER))
        end
      when 'reg'
        if !all.nil? && all == 'all'
          get_commands(%w(REGULAR SUBSCRIBER DEFAULT))
        else
          get_commands('REGULAR')
        end
      when 'mod'
        if !all.nil? && all == 'all'
          get_commands(%w(MODERATOR REGULAR SUBSCRIBER DEFAULT))
        else
          get_commands('MODERATOR')
        end
      when 'smd'
        if !all.nil? && all == 'all'
          get_commands(%w(SUPER_MODERATOR MODERATOR REGULAR SUBSCRIBER DEFAULT))
        else
          get_commands('SUPER_MODERATOR')
        end
      when 'own'
        if !all.nil? && all == 'all'
          get_commands(%w(BROADCASTER SUPER_MODERATOR MODERATOR REGULAR SUBSCRIBER DEFAULT))
        else
          get_commands('BROADCASTER')
        end
      when 'int'
        get_commands('INTERNAL')
      else
    end
  end

  def aliases
    @channel = params[:channel]
    get_aliases
  end

  def quotes
    @channel = params[:channel]
    get_quotes
  end

  def get_quotes
    ActiveRecord::Base.establish_connection adapter: 'sqlite3', database: "~/.otbproject/data/channels/#{@channel}/quotes.db"
    @quote = Quote.all
    @quote.to_a.sort!
  end

  def get_aliases
    ActiveRecord::Base.establish_connection adapter: 'sqlite3', database: "~/.otbproject/data/channels/#{@channel}/main.db"
    @alias = Alias.where enabled: 'true'
    @alias.to_a.sort!
    @commands = Hash.new
    @alias.each do |a|
      @commands[a] = get_command a.command
    end
  end

  def get_command(command)
    Command.find_by_name command.split ' '
  end

  def get_commands(user_level)
    ActiveRecord::Base.establish_connection adapter: 'sqlite3', database: "~/.otbproject/data/channels/#{@channel}/main.db"
    @command = Command.where execUserLevel: user_level
    @command.to_a.sort!
  end
end