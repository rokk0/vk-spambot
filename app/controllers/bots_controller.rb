require 'net/http'
require 'encryptor'

class BotsController < ApplicationController
  include BotsHelper

  before_filter :user_access,               :only => [:edit, :update, :show, :destroy]
  before_filter :user_access_create,        :only => [:new, :create]
  before_filter :user_access_control,       :only => [:run, :stop]
  before_filter :user_access_control_all,   :only => [:run_all, :stop_all]

  def index
    if current_user.id != params[:user_id].to_i && !current_user.admin?
      flash_access_denied
    else
      @bots  = User.find(params[:user_id]).bots.paginate(:page => params[:page])
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
    user = User.find(@bot.user_id)
    if user.admin? && !current_user?(user) && current_user.admin?
      flash_access_denied
    else
      @bot.stop
      @bot.destroy
      redirect_to user_bots_path(user.id), :flash => { :success => 'Bot destroyed.' }
    end
  end

  def run
    respond_to { |format| format.json { render :json => @bot.run } }
  end

  def stop
    respond_to { |format| format.json { render :json => @bot.stop } }
  end

  def run_all
    statuses = []

    User.find(params[:user_id].to_i).bots.each do |bot|
    end

    respond_to { |format| format.json { render :json => { :statuses => statuses } } }
  end

  def stop_all
    respond_to { |format| format.json { render :json => @user.stop_bots } }
  end

  def check_status
    begin
      response = RestClient.get "#{$service_url}/api/user/#{params[:user_id]}/bots"
    rescue
      response = {}
    end

    respond_to { |format| format.json { render :json => response } }
  end

end
