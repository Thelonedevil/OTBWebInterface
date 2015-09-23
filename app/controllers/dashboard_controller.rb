require 'json'
require 'ipaddr'
require 'java'

class DashboardController < ApplicationController

  def allowed?
    file = File.read("#{::DIR_BASE}/config/web-config.json")
    data = JSON.parse file
    ip_addresses_with_prefix = data['writableWhitelist'].to_a
    ip_addresses_with_prefix.each do |i|
      ip = IPAddr.new i
      if ip.include? request.remote_ip
        render :json => '1'.to_json
        return
      end
    end
    render :json => '0'.to_json
  end

  def commands_edit
    ActiveRecord::Base.establish_connection adapter: 'sqlite3', database: "#{::DIR_BASE}/data/channels/#{params[:channel]}/main.db"
    if params.has_key? :old_command
      command = Command.find_by_name params[:old_command].to_s
    else
      command = Command.new
    end
    changed=false
    case params[:action_type]
      when 'delete'
        if Command.exists? command.name.to_s
          command.destroy
          changed=true
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
        changed=true
      when 'new'
        unless Command.exists? params[:command]
          command.name = params[:command].to_s
          command.response = params[:response].to_s.empty? ? 'example response' : params[:response].to_s
          command.script = params[:script].to_s.empty? ? nil : params[:script].to_s
          command.minArgs = params[:minArgs].to_s
          command.count = 0
          command.debug = params[:debug].to_s.empty? ? 'false' : params[:debug].to_s.downcase
          command.responseModifyingUL = params[:rMUL].to_s.empty? ? 'DEFAULT' : params[:rMUL].to_s.upcase
          command.nameModifyingUL = params[:nMUL].to_s.empty? ? 'DEFAULT' : params[:nMUL].to_s.upcase
          command.userLevelModifyingUL = params[:ulMUL].to_s.empty? ? 'DEFAULT' : params[:ulMUL].to_s.upcase
          command.execUserLevel = params[:eUL].to_s.empty? ? 'DEFAULT' : params[:eUL].to_s.upcase
          command.enabled='true'
          command.save
          changed=true
        end

      when 'toggle'
        if Command.exists? command.name
          command.enabled = command.enabled=='true' ? 'false' : 'true'
          command.save
          changed=true
        end
      else
        changed=false
    end
    render :json => changed ? 1.to_json : 0.to_json
  end

  def aliases_edit
    ActiveRecord::Base.establish_connection adapter: 'sqlite3', database: "#{::DIR_BASE}/data/channels/#{params[:channel]}/main.db"
    if params.has_key? :old_alias
      aliasObj = Alias.find_by_name params[:old_alias].to_s
    else
      aliasObj = Alias.new
    end
    changed=false
    case params[:action_type]
      when 'delete'
        if Alias.exists? aliasObj.name.to_s
          aliasObj.destroy
          changed=true
        end
      when 'edit'
        unless Alias.exists? params[:alias].to_s
          aliasObj.name = params[:alias].to_s
        end
        aliasObj.command = params[:command].to_s
        aliasObj.modifyingUL= params[:mUL].to_s
        aliasObj.save
        changed=true
      when 'new'
        unless Alias.exists? params[:alias]
          aliasObj.name = params[:alias].to_s
          aliasObj.command = params[:command].to_s
          aliasObj.modifyingUL= params[:mUL].to_s
          aliasObj.enabled='true'
          aliasObj.save
          changed=true
        end

      when 'toggle'
        if Alias.exists? aliasObj.name
          aliasObj.enabled = aliasObj.enabled=='true' ? 'false' : 'true'
          aliasObj.save
          changed=true
        end
      else
        changed=false
    end
    render :json => changed ? 1.to_json : 0.to_json
  end

  def get_quotes
    ActiveRecord::Base.establish_connection adapter: 'sqlite3', database: "#{::DIR_BASE}/data/channels/#{params[:channel]}/quotes.db"
    quote = Quote.all
    quote.to_a.sort!
    render :json => quote.to_json
  end

  def get_aliases
    ActiveRecord::Base.establish_connection adapter: 'sqlite3', database: "#{::DIR_BASE}/data/channels/#{params[:channel]}/main.db"
    aliases = Alias.all
    aliases.to_a.sort!
    render :json => aliases.to_json
  end

  def get_channel_name
    render :json => params[:channel].to_json
  end

  def get_command
    render :json => Command.find_by_name(params[:command].to_s.split[0]).as_json
  end

  def get_alias
    render :json => Alias.find_by_name(params[:alias].to_s).as_json
  end

  def get_commands
    user_level = params[:id].to_s
    if params[:below] == 'true'
      case user_level
        when 'INTERNAL'
          user_level = %w(DEFAULT SUBSCRIBER REGULAR MODERATOR SUPER_MODERATOR BROADCASTER INTERNAL)
        when 'BROADCASTER'
          user_level = %w(DEFAULT SUBSCRIBER REGULAR MODERATOR SUPER_MODERATOR BROADCASTER)
        when 'SUPER_MODERATOR'
          user_level = %w(DEFAULT SUBSCRIBER REGULAR MODERATOR SUPER_MODERATOR)
        when 'MODERATOR'
          user_level = %w(DEFAULT SUBSCRIBER REGULAR MODERATOR)
        when 'REGULAR'
          user_level = %w(DEFAULT SUBSCRIBER REGULAR)
        when 'SUBSCRIBER'
          user_level = %w(DEFAULT SUBSCRIBER)
        when 'ALL'
          user_level = %w(DEFAULT SUBSCRIBER REGULAR MODERATOR SUPER_MODERATOR BROADCASTER INTERNAL)
        else
          user_level = user_level
      end
    end
    if user_level == 'ALL'
      user_level = %w(DEFAULT SUBSCRIBER REGULAR MODERATOR SUPER_MODERATOR BROADCASTER INTERNAL)
    end
    ActiveRecord::Base.establish_connection adapter: 'sqlite3', database: "#{::DIR_BASE}/data/channels/#{params[:channel]}/main.db"
    commands = Command.where execUserLevel: user_level
    commands.to_a.sort!
    render :json => commands.to_json
  end

  def get_user_levels
    render :json => %w(DEFAULT SUBSCRIBER REGULAR MODERATOR SUPER_MODERATOR BROADCASTER INTERNAL).reverse!.to_json
  end
end