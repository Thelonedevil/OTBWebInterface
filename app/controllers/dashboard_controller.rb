require 'json'
require 'ipaddr'
class DashboardController < ApplicationController
  def allowed?
    file = File.read("#{Dir.home}/.otbproject/config/web-config.json")
    data = JSON.parse file
    ip_addresses_with_prefix = data['writableWhitelist'].to_a
    ip_addresses_with_prefix.each do |i|
      ip = IPAddr.new i
      if ip.include? request.remote_ip
        return true
      end
    end
    false
  end

  def commands
    @writable = allowed?
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

  def commands_edit
    ActiveRecord::Base.establish_connection adapter: 'sqlite3', database: "~/.otbproject/data/channels/#{params[:channel]}/main.db"
    if params.has_key? :old_command
         command = Command.find_by_name params[:old_command].to_s
      else
        command = Command.new
      end
      case params[:action_type]
        when 'delete'
          if Command.exists? command.name.to_s
            command.destroy
          end
        when 'edit'
          unless Command.exists? params[:command].to_s
            command.name = params[:command].to_s
          end
          command.response = params[:response].to_s
          command.minArgs = params[:minArgs].to_s
          command.responseModifyingUL = params[:rMUL].to_s.upcase
          command.nameModifyingUL = params[:nMUL].to_s.upcase
          command.userLevelModifyingUL = params[:ulMUL].to_s.upcase
          command.execUserLevel = params[:eUL].to_s.upcase
          command.save
        when 'new'
          unless Command.exists? params[:command]
            command.name = params[:command].to_s
            command.response = params[:response].to_s.empty? ? 'example response' : params[:response].to_s
            command.script = params[:script].to_s.empty? ? nil : params[:script].to_s
            command.minArgs = params[:minArgs].to_s
            command.count = 0
            command.debug = params[:debug].to_s.empty? ? 'false' : params[:rMUL].to_s.downcase
            command.responseModifyingUL = params[:rMUL].to_s.empty? ? 'DEFAULT' : params[:rMUL].to_s.upcase
            command.nameModifyingUL = params[:nMUL].to_s.empty? ? 'DEFAULT' : params[:nMUL].to_s.upcase
            command.userLevelModifyingUL = params[:ulMUL].to_s.empty? ? 'DEFAULT' : params[:ulMUL].to_s.upcase
            command.execUserLevel = params[:eUL].to_s.empty? ? 'DEFAULT' : params[:eUL].to_s.upcase
            command.enabled='true'
            command.save
          end

        when 'toggle'
          if Command.exists? command.name
            command.enabled = command.enabled=='true' ? 'false' : 'true'
            command.save
          end
        else
      end
      commands
      render 'dashboard/commands'
    end

    def aliases
      @writable = allowed?
      @channel = params[:channel]
      get_aliases
    end

    def quotes
      @writable = allowed?
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
      @alias = Alias.all
      @alias.to_a.sort!
      @commands = Hash.new
      @alias.each do |a|
        unless a.command.nil?
          @commands[a] = get_command a.command
        end
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