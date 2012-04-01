require 'core/bot'
require 'bots/group'
require 'bots/discussion'
#require 'openwfe/util/scheduler'
#include OpenWFE

class BotsController < ApplicationController
  # GET /bots
  # GET /bots.json
  def index
    @bots = current_user.bots

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @bots }
    end
  end

  # GET /bots/1
  # GET /bots/1.json
  def show
    begin
      @bot = current_user.bots.find(params[:id])
    rescue
      render "error"
    else
      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @bot }
      end
    end
  end
  # GET /bots/new
  # GET /bots/new.json
  def new
    @bot = Bot.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @bot }
    end
  end

  # GET /bots/1/edit
  def edit
    @bot = current_user.bots.find(params[:id])
    @bot.password = ""
    rescue
      render "error"
  end

  # POST /bots
  # POST /bots.json
  def create
    params[:bot][:user_id] = current_user.id
    @bot = Bot.new(params[:bot])

    respond_to do |format|
      if @bot.save
        format.html { redirect_to @bot, notice: 'Bot was successfully created.' }
        format.json { render json: @bot, status: :created, location: @bot }
      else
        format.html { render action: "new" }
        format.json { render json: @bot.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /bots/1
  # PUT /bots/1.json
  def update
    begin
      @bot = current_user.bots.find(params[:id])
    rescue
      render "error"
    else
      respond_to do |format|
        if @bot.update_attributes(params[:bot])
          format.html { redirect_to @bot, notice: 'Bot was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render action: "edit" }
          format.json { render json: @bot.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /bots/1
  # DELETE /bots/1.json
  def destroy
    begin
      @bot = current_user.bots.find(params[:id])
    rescue
      render "error"
    else
      @bot.destroy

      respond_to do |format|
        format.html { redirect_to bots_url }
        format.json { head :no_content }
      end
    end
  end

  def run
    begin
      @bot = current_user.bots.find(params[:id])
    rescue
      response = { 'state' => 'error' }
    else
      #test = %x[rake spam:group email=#{@bot.email} password=#{@bot.password}, page=#{@bot.page}, hash=#{@bot.page_hash}, message=#{@bot.message}, count=#{@bot.count} interval=#{@bot.interval}]
      user_bot = runBot(@bot)
      if user_bot.initLogin
      #  scheduler = Scheduler.new
      #  scheduler.start
      #  scheduler.schedule_every("5s") { bot_init.spam }
      #  scheduler.join
        user_bot.spam
        response = { 'state' => 'ok' }
      else
        response = { 'state' => 'login error' }
      end
    end

    respond_to do |format|
      format.json { render :json => response }
    end
  end

  def stop
    begin
      @bot = current_user.bots.find(params[:id])
    rescue
      response = { 'state' => 'error' }
    else
      #test = %x[rake spam:group email=#{@bot.email} password=#{@bot.password}, page=#{@bot.page}, hash=#{@bot.page_hash}, message=#{@bot.message}, count=#{@bot.count} interval=#{@bot.interval}]
      #user_bot = runBot(@bot)
      #if user_bot.initLogin
      #  user_bot.spam
        response = { 'state' => 'ok' }
      #else
      #  response = { 'state' => 'login error' }
      #end
    end

    respond_to do |format|
      format.json { render :json => response }
    end
  end

  private

    def runBot(bot)
      if bot.bot_type == 'group'
        _bot = Bots::Group.new(bot.email, bot.password, bot.page, bot.page_hash, bot.message, bot.count)
      elsif bot.bot_type == 'discussion'
        _bot = Bots::Discussion.new(bot.email, bot.password, bot.page, bot.page_hash, bot.message, bot.count)
      else
        return false
      end

      return _bot
    end

end