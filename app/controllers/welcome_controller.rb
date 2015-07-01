class WelcomeController < ApplicationController
  def index
    Dir.chdir Dir.home
    @channels = []
    Dir.foreach'.otbproject/data/channels' do |item|
      next if item == '.' or item=='..'
      @channels << item
    end
    @channels.sort!
  end
end
