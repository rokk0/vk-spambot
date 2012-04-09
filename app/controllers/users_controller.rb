class UsersController < ApplicationController
  before_filter :check_user,   :only => [:show, :edit, :update, :destroy]
  before_filter :authenticate, :only => [:index, :edit, :update, :destroy]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user,   :only => :destroy

  def index
    @title = "All users"
    @users = User.paginate(:page => params[:page])
  end

  def show
    @title = @user.name
  end

  def new
    @user = User.new
    @title = "Sign up"
  end

  def edit
    @title = "Edit user"
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      redirect_to @user, :flash => { :success => "Welcome to the... dunno!" }
    else
      @title = "Sign up"
      @user.password = ""
      @user.password_confirmation = ""
      render 'new'
    end
  end

  def update
    if @user.update_attributes(params[:user])
      redirect_to @user, :flash => { :success => "Profile was successfully updated." }
    else
      @title = "Edit user"
      render 'edit'
    end
  end

  def destroy
    if @user.admin?
      _flash = { :error => "Administrator cannot be destroyed." }
    else
      @user.destroy
      _flash = { :success => "User destroyed." }
    end
    redirect_to :back, :flash => _flash
  end

  private

    def authenticate
      deny_access unless signed_in?
    end

    def correct_user
      @user = User.find(params[:id])
      if !current_user?(@user) && ( !current_user.admin? || @user.admin? )
        flash.now[:error] = "Access denied."
        render "error"
      end
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
 
    def check_user
      @user = User.find(params[:id])
      rescue
        flash.now[:error] = "User not found."
        render "error"
    end
end
