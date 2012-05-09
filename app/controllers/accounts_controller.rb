class AccountsController < ApplicationController
  include AccountsHelper

  before_filter :authenticate_user!
  before_filter :check_account, :only => [:show, :edit, :update, :destroy]
  #before_filter :user_access,               :only => [:edit, :update, :show, :destroy]
  #before_filter :user_access_create,        :only => [:new, :create]

  #load_and_authorize_resource
  load_and_authorize_resource :user
  load_and_authorize_resource :account, :through => :user, :shallow => true

  def index
    #authorize! :index, @user, :message => 'Not authorized as an administrator.'
      @accounts  = User.find(params[:user_id]).accounts.paginate(:page => params[:page])
      @title = 'Listing accounts'
    #end
  rescue
    flash_access_denied
  end

  def show
  end

  def new
    @account = Account.new
    @title = 'New account'
  end

  def edit
    @account = Account.find(params[:id])
    @account.password = nil
    @title = 'Edit account'
  end

  def create
    params[:account][:user_id] = current_user.has_role?(:admin) ? params[:user_id] || current_user.id : current_user.id
    @account = Account.new(params[:account])

    if @account.save
      redirect_to user_account_bots_path(@account.user_id, @account.id), :flash => { :success => 'Account was successfully created.' }
    else
      @title = 'New account'
      render 'new'
    end
  end

  def update
    @account = Account.find(params[:id])
    if @account.update_attributes(params[:account])
      redirect_to user_accounts_path(@account.user_id), :flash => { :success => 'Account was successfully updated.' }
    else
      @title = 'Edit account'
      render 'edit'
    end
  end

  def destroy
    @account = Account.find(params[:id])

    @account.stop_bots

    # To stop bots after (bots.count * 10) seconds if user destroyed in short period of time after 'run' request
    Thread.new do
      sleep @account.bots.count * 10
      @account.stop_bots
    end

    @account.destroy
    redirect_to user_accounts_path(@account.user_id), :flash => { :success => 'Account destroyed.' }
  end

end
