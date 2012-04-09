require 'core/bot'
require 'bots/group'
require 'bots/discussion'
#require 'openwfe/util/scheduler'
#include OpenWFE

class BotsController < ApplicationController
  include BotsHelper

  before_filter :user_bot,          :only => [:edit, :update, :show, :destroy]
  before_filter :user_bot_create,   :only => [:new, :create]
  before_filter :user_bot_control,  :only => [:run, :stop]

  def index
    if !current_user.admin? && current_user.id != params[:id].to_i 
      flash_access_denied
    else
      @bots = current_user.admin? && params[:id] ? User.find(params[:id]).bots : current_user.bots
      @title = "Listing bots"
    end
    rescue
        flash_access_denied
  end

  def show
  end

  def new
    @bot = Bot.new
    @title = "New bot"
  end

  def edit
    @bot.password = ""
    @title = "Edit bot"
  end

  def create
    params[:bot][:user_id] = current_user.admin? ? params[:id] || current_user.id : current_user.id
    @bot = Bot.new(params[:bot])

    if @bot.save
      redirect_to @bot, :flash => { :success => "Bot was successfully created." }
    else
      @title = "New bot"
      render 'new'
    end
  end

  def update
    if @bot.update_attributes(params[:bot])
      redirect_to @bot, :flash => { :success => "Bot was successfully updated." }
    else
      @title = "Edit bot"
      render 'edit'
    end
  end

  def destroy
    _user = User.find(@bot.user_id)
    if !current_user?(_user) && _user.admin? && current_user.admin?
      flash_access_denied
    else
      @bot.destroy
      redirect_to :back, :flash => { :success => "Bot destroyed." }
    end
  end

  def run
    user_bot = initBot(@bot)

    if user_bot.loggedIn
      user_bot.spam
    end

    respond_to do |format|
      format.json { render :json => { 'state' => user_bot.loginState } }
    end
  end

  def stop
    response = { 'state' => 'ok' }

    respond_to do |format|
      format.json { render :json => response }
    end
  end

  private

    # general method to initialize bot
    def initBot(bot)
      _bot = ('Bots::' + bot.bot_type.capitalize).constantize.new(bot.email, bot.password, bot.page, bot.page_hash, bot.message, bot.count)
      return _bot
    end

    # check user access to all information about bots except listing.
    def user_bot
      @bot = current_user.admin? ? Bot.find(params[:id]) : current_user.bots.find(params[:id])
      user_bot_helper(@bot.user_id)
      rescue
        flash_access_denied
    end

    # check user access to create bots.
    def user_bot_create
      user_bot_helper(params[:id])
    end

    # check user access to run/stop bots.
    def user_bot_control
      _bot = Bot.find(params[:id])
      @bot = current_user.admin? ? ( !User.find(_bot.user_id).admin? ? _bot : current_user.bots.find(params[:id]) ) : current_user.bots.find(params[:id])
      rescue
        respond_to do |format|
          format.json { render :json => { 'state' => 'access denied' } }
        end
    end

end