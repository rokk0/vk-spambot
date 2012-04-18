require 'core/vk'
require 'bots/group'
require 'bots/discussion'
#require 'openwfe/util/scheduler'
#include OpenWFE

class BotsController < ApplicationController
  include BotsHelper

  before_filter :user_access,               :only => [:edit, :update, :show, :destroy]
  before_filter :user_access_create,        :only => [:new, :create]
  before_filter :user_access_control,       :only => [:run, :stop]
  before_filter :user_access_control_all,   :only => [:run_all]

  def index
    if !current_user.admin? && current_user.id != params[:user_id].to_i 
      flash_access_denied
    else
      @bots  = (current_user.admin? && params[:user_id] ? User.find(params[:user_id]).bots : current_user.bots).paginate(:page => params[:page])
      @title = 'Listing bots'
    end
  rescue
    flash_access_denied
  end

  def show
  end

  def new
    @bot   = Bot.new
    @title = 'New bot'
  end

  def edit
    @bot.password = nil
    @title = 'Edit bot'
  end

  def create
    params[:bot][:user_id] = current_user.admin? ? params[:user_id] || current_user.id : current_user.id
    @bot = Bot.new(params[:bot])

    if @bot.save
      redirect_to @bot, :flash => { :success => 'Bot was successfully created.' }
    else
      @title = 'New bot'
      render 'new'
    end
  end

  def update
    if @bot.update_attributes(params[:bot])
      redirect_to @bot, :flash => { :success => 'Bot was successfully updated.' }
    else
      @title = 'Edit bot'
      render 'edit'
    end
  end

  def destroy
    _user = User.find(@bot.user_id)
    if !current_user?(_user) && _user.admin? && current_user.admin?
      flash_access_denied
    else
      @bot.destroy
      redirect_to user_bots_path(_user.id), :flash => { :success => 'Bot destroyed.' }
    end
  end

  def run
    respond_to { |format| format.json { render :json => run_bot(@bot) } }
  end

  def stop
    response = { 'state' => 'ok' }

    respond_to { |format| format.json { render :json => response } }
  end

  def run_all
    states = []

    User.find(params[:user_id].to_i).bots.each do |bot|
      states.push(run_bot(bot))
    end

    respond_to { |format| format.json { render :json => { 'states' => states } } }
  end

  private

    # general method to initialize bot
    def init_bot(bot)
      _bot = ('Bots::' + bot.bot_type.capitalize).constantize.new(bot.id, bot.email, bot.password, bot.page, bot.page_hash, bot.message, bot.count, bot.code)
    end

    # general method to run bot with hash check
    def run_bot(bot)
      _bot = init_bot(bot)

      if _bot.logged_in?
        if bot.page_hash.empty?
          bot.update_attributes(:page_hash => _bot.get_hash(bot.page))
        end
        _bot.spam
      end

      return { 'state' => "##{bot.id} - #{_bot.login_state}" }
    end

end