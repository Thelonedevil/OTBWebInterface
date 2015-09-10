require 'java'
class WelcomeController < ApplicationController
  def index
    Dir.chdir ::DIR_BASE
    @channels = []
    Dir.foreach ::DIR_BASE+'/data/channels' do |item|
      next if item == '.' or item=='..'
      @channels << item
    end
    @channels.sort!
  end
end
