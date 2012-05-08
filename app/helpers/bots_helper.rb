module BotsHelper

  private

    # check user access to all information about bots except listing.
    def user_access
      @bot = current_user.admin? ? Bot.find(params[:id]) : current_user.bots.find(params[:id])

      check_user_access(@bot.account.user_id)

    rescue
      flash_access_denied
    end

    # check user access to create bots.
    def user_access_create
      check_user_access(params[:user_id])
    end

    # check user access to run/stop bots.
    def user_access_control
      bot = Bot.find(params[:id])

      if current_user.admin?
        @bot = User.find(bot.account.user_id).admin? ? current_user.bots.find(params[:id]) : bot
      else
        @bot = current_user.bots.find(params[:id])
      end

    rescue
      response_access_denied
    end

    # check user access to run/stop all bots by user_id
    def user_access_control_all
      @user = User.find(params[:user_id])

      unless !@user.admin? && current_user.admin? || current_user?(@user)
        response_access_denied
      end

    rescue
      response_access_denied
    end

    # check user access to run/stop all bots by account_id
    def user_access_control_account_all
      @account  = Account.find(params[:account_id])
      user      = @account.user

      unless !user.admin? && current_user.admin? || current_user?(user)
        response_access_denied
      end

    rescue
      response_access_denied
    end

    # check user access to actions with bots, also return exception if user not found.
    def check_user_access(user_id)
    ##  user = User.find(user_id)

    ##  flash_access_denied unless !user.admin? && current_user.admin? || current_user?(user)

    ##rescue
    ##  flash_user_not_found
      current_user
    end

    def response_access_denied
      respond_to { |format| format.json { render :json => { :status => :error, :message => 'access denied' } } }
    end

end
