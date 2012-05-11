require 'net/http'
require 'encryptor'

class BotsController < ApplicationController
  include BotsHelper

  before_filter :authenticate_user!

  before_filter :check_user,    :only => [:index, :show, :new, :create, :edit, :update, :destroy]
  before_filter :check_account, :only => [:index, :show, :new, :create, :edit, :update, :destroy]
  before_filter :check_bot,     :only => [:show, :edit, :update, :destroy]

  before_filter :check_access_control,             :only => [:run, :stop]
  before_filter :check_access_control_all,         :only => [:run_all, :stop_all]
  before_filter :check_access_control_account_all, :only => [:run_account_all, :stop_account_all]

  load_and_authorize_resource :user
  load_and_authorize_resource :account
  load_and_authorize_resource :bot, :through => :account, :shallow => true

  def index
    unless params[:account_id].nil?
      @bots = @account.bots.paginate(:page => params[:page])
    else
      @bots = @user.bots.paginate(:page => params[:page])
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
    interval     = @bot.interval.scan(/(\d+)h(\d+)m/).flatten
    @bot.hours   = interval.first
    @bot.minutes = interval.second

    @title = 'Edit bot'
  end

  def create
    user_id    = params[:user_id]
    account_id = params[:account_id]

    @bot = Bot.new(params[:bot])

    if @bot.save
      if account_id.nil?
        redirect_to user_bots_path(user_id),
              :flash => { :success => 'Bot was successfully created.' }
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
    user_id    = params[:user_id]
    account_id = params[:account_id]

    if @bot.update_attributes(params[:bot])
      if account_id.nil?
        redirect_to user_bots_path(user_id),
              :flash => { :success => 'Bot was successfully updated.' }
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
    user_id    = params[:user_id]
    account_id = params[:account_id]

    # To stop bot after 10 seconds if bot destroyed in short period of time after 'run' request
    Thread.new do
      sleep 10
      @bot.stop
    end

    @bot.destroy
    if account_id.nil?
      redirect_to user_bots_path(user_id),
            :flash => { :success => 'Bot was successfully destroyed.' }
    else
      redirect_to user_account_bots_path(user_id, account_id),
            :flash => { :success => 'Bot was successfully destroyed.' }
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
