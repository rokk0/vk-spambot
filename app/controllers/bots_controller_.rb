require 'core/bot'
require 'bots/group'
require 'bots/discussion'

class BotsController < ApplicationController
  def show
    @model = Bot.find(params[:id])
    @title = @model.name
  end
  def new
    @model = Bot.new
    @title = "New bot"
  end
  def create
    @model = Bot.new(params[:bot])
    if @model.save
      flash[:success] = "Bot created!"
      redirect_to @model
    else
      @title = "New bot"
      @user.password = ""
      render 'new'
    end
  end
  def run
    @model = Bot.new
    @title = "Bot run"
  end
  def stop
    @title = "Bot stop"
  end
end
