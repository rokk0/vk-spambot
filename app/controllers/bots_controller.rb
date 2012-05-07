require 'net/http'
require 'encryptor'

class BotsController < ApplicationController
  include BotsHelper

  before_filter :user_access,                     :only => [:edit, :update, :show, :destroy]
  before_filter :user_access_create,              :only => [:new, :create]
  before_filter :user_access_control,             :only => [:run, :stop]
  before_filter :user_access_control_all,         :only => [:run_all, :stop_all]
  before_filter :user_access_control_account_all, :only => [:run_account_all, :stop_account_all]

  def index
    if current_user.id != params[:user_id].to_i && !current_user.admin?
      flash_access_denied
    elsif params[:account_id] != nil
      @bots  = Account.find(params[:account_id]).bots.paginate(:page => params[:page])
    else
      @bots  = User.find(params[:user_id]).bots.paginate(:page => params[:page])
    end

    @title = 'Listing bots'
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
    interval      = @bot.interval.scan(/(\d+)h(\d+)m/).flatten
    @bot.hours    = interval.first
    @bot.minutes  = interval.second

    @title = 'Edit bot'
  end

  def create
    user_id     = current_user.admin? ? params[:user_id] || current_user.id : current_user.id
    account_id  = params[:account_id]

    @bot = Bot.new(params[:bot])

    if @bot.save
      if account_id.nil?
        redirect_to user_bots_path(user_id), :flash => { :success => 'Bot was successfully created.' }
      else
        redirect_to user_account_bots_path(user_id, account_id), 
              :flash => { :success => 'Bot was successfully created.' }
      end
    else
      @title = 'New bot'
      render 'new'
    end
  end

  def update
    user_id     = params[:user_id]
    account_id  = params[:account_id]

    if @bot.update_attributes(params[:bot])
      if account_id.nil?
        redirect_to user_bots_path(user_id), :flash => { :success => 'Bot was successfully updated.' }
      else
        redirect_to user_account_bots_path(user_id, account_id), 
              :flash => { :success => 'Bot was successfully updated.' }
      end
    else
      @title = 'Edit bot'
      render 'edit'
    end
  end

  def destroy
    user        = User.find(params[:user_id])
    account_id  = params[:account_id]

    if user.admin? && !current_user?(user) && current_user.admin?
      flash_access_denied
    else
      # To stop bot after 10 seconds if bot destroyed in short period of time after 'run' request
      Thread.new do
        sleep 10
        @bot.stop
      end

      @bot.destroy
      if account_id.nil?
        redirect_to user_bots_path(user.id), :flash => { :success => 'Bot was successfully destroyed.' }
      else
        redirect_to user_account_bots_path(user.id, account_id), 
              :flash => { :success => 'Bot was successfully destroyed.' }
      end
    end
  end

  def run
    respond_to { |format| format.json { render :json => @bot.run } }
  end

  def stop
    respond_to { |format| format.json { render :json => @bot.stop } }
  end

  def run_account_all
    respond_to { |format| format.json { render :json => { :statuses => @account.run_bots } } }
  end

  def stop_account_all
    respond_to { |format| format.json { render :json => @account.stop_bots } }
  end

  def run_all
    respond_to { |format| format.json { render :json => { :statuses => @user.run_bots } } }
  end

  def stop_all
    respond_to { |format| format.json { render :json => @user.stop_bots } }
  end

  def check_status
    respond_to { |format| format.json { render :json => Bot.check_status(params[:user_id]) } }
  end

end
