class AccountsController < ApplicationController
  include AccountsHelper

  before_filter :user_access,               :only => [:edit, :update, :show, :destroy]
  before_filter :user_access_create,        :only => [:new, :create]

  def index
    if current_user.id != params[:user_id].to_i && !current_user.admin?
      flash_access_denied
    else
      @accounts  = User.find(params[:user_id]).accounts.paginate(:page => params[:page])
      @title = 'Listing accounts'
    end
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
    @account.password = nil
    @title = 'Edit account'
  end

  def create
    params[:account][:user_id] = current_user.admin? ? params[:user_id] || current_user.id : current_user.id
    @account = Account.new(params[:account])

    if @account.save
      redirect_to user_account_bots_path(@account.user_id, @account.id), :flash => { :success => 'Account was successfully created.' }
    else
      @title = 'New account'
      render 'new'
    end
  end

  def update
    if @account.update_attributes(params[:account])
      redirect_to user_accounts_path(@account.user_id), :flash => { :success => 'Account was successfully updated.' }
    else
      @title = 'Edit account'
      render 'edit'
    end
  end

  def destroy
    user = User.find(@account.user_id)
    if user.admin? && !current_user?(user) && current_user.admin?
      flash_access_denied
    else
      @account.stop_bots

      # To stop bots after (bots.count * 10) seconds if user destroyed in short period of time after 'run' request
      Thread.new do
        sleep @account.bots.count * 10
        @account.stop_bots
      end

      @account.destroy
      redirect_to user_accounts_path(user.id), :flash => { :success => 'Account destroyed.' }
    end
  end

end
