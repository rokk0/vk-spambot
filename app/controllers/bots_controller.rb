require 'net/http'
require 'encryptor'

class BotsController < ApplicationController
  include BotsHelper

  before_filter :user_access,               :only => [:edit, :update, :show, :destroy]
  before_filter :user_access_create,        :only => [:new, :create]
  before_filter :user_access_control,       :only => [:run, :stop]
  before_filter :user_access_control_all,   :only => [:run_all, :stop_all]

  def index
    if !current_user.admin? && current_user.id != params[:user_id].to_i 
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
    _user = User.find(@bot.user_id)
    if !current_user?(_user) && _user.admin? && current_user.admin?
      flash_access_denied
    else
      @bot.destroy
      redirect_to user_bots_path(_user.id), :flash => { :success => 'Bot destroyed.' }
    end
  end

  def run
    _data = Hash.new(nil)
    data = @bot.attributes.except("created_at", "updated_at")
    data.each_pair { |k,v| _data.store(k.to_sym,v.to_s) }

    data = {
      :bot => Encryptor.encrypt(_data.to_json, :key => $secret_key)
    }

    begin
      response = RestClient.post "#{$service_url}/api/bot/run", data, { :content_type => :json, :accept => :json }

      page_title = JSON.parse(response.body)['page_title']
      unless page_title.nil?
        @bot.update_attributes(:page_title => page_title)
      end

      page_hash = JSON.parse(response.body)['page_hash']
      unless page_hash.nil?
        @bot.update_attributes(:page_hash => page_hash)
      end

    rescue => error
      response = { :status => :error, :message => "##{@bot.id} - #{error}" }
    end

    respond_to { |format| format.json { render :json => response } }
  end

  def stop
    data = { :id => "#{@bot.id}" }

    data = {
      :bot => Encryptor.encrypt(data.to_json, :key => $secret_key)
    }

    begin
      response = RestClient.post "#{$service_url}/api/bot/stop", data, { :content_type => :json, :accept => :json }
    rescue => error
      response = { :status => :error, :message => "##{@bot.id} - #{error}" }
    end

    respond_to { |format| format.json { render :json => response } }
  end

  def run_all
    statuses = []

    User.find(params[:user_id].to_i).bots.each do |bot|
    end

    respond_to { |format| format.json { render :json => { :statuses => statuses } } }
  end

  def stop_all
    #params[:user_id]

    respond_to { |format| format.json { render :json => {} } }
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