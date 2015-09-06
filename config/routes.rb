Rails.application.routes.draw do

  get 'dashboard/:channel/commands/' => 'dashboard#commands'

  get 'dashboard/:channel/commands/get_channel_name' => 'dashboard#get_channel_name'

  get 'dashboard/get_user_levels' => 'dashboard#get_user_levels'

  get 'dashboard/:channel/commands/get_commands' => 'dashboard#get_commands'

  get 'dashboard/:channel/aliases/' => 'dashboard#aliases'
  get 'dashboard/:channel/aliases/get_channel_name' => 'dashboard#get_channel_name'
  get 'dashboard/:channel/aliases/get_aliases' => 'dashboard#get_aliases'
  get 'dashboard/:channel/aliases/get_command' => 'dashboard#get_command'

  get 'dashboard/:channel/quotes' => 'dashboard#quotes'
  get 'dashboard/:channel/quotes/get_channel_name' => 'dashboard#get_channel_name'
  get 'dashboard/:channel/quotes/get_quotes' => 'dashboard#get_quotes'

  get 'welcome/index'

  root 'welcome#index'

end
