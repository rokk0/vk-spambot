module BotsHelper

  private

    def check_user
      @user = User.find(params[:user_id])
    rescue
      flash_user_not_found
    end

    def check_account
      @account = Account.find(params[:account_id]) unless params[:account_id].nil?
    rescue
      flash_account_not_found
    end

    def check_bot
      @bot = Bot.find(params[:id])
    rescue
      flash_bot_not_found
    end

    # check user access to all information about bots except listing.
    #def user_access
    #  @bot = current_user.has_role?(:admin) ? Bot.find(params[:id]) : current_user.bots.find(params[:id])

    #  check_user_access(@bot.account.user_id)

    #rescue
    #  flash_access_denied
    #end

    # check user access to create bots.
    #def user_access_create
    #  check_user_access(params[:user_id])
    #end

    # check user access to actions with bots, also return exception if user not found.
    #def check_user_access(user_id)
    ##  user = User.find(user_id)

    ##  flash_access_denied unless !user.has_role?(:admin) && current_user.has_role?(:admin) || current_user?(user)

    ##rescue
    ##  flash_user_not_found
    #  current_user
    #end

    # check user access to run/stop bots.
    def check_access_control
      @bot = Bot.find(params[:id])

      response_access_denied unless current_user.has_role?(:admin) || current_user.id == @bot.account.user_id
    rescue
      response_access_denied
    end

    # check user access to run/stop all bots by user_id
    def check_access_control_all
      @user = User.find(params[:user_id])

      response_access_denied unless current_user.has_role?(:admin) || current_user.id == @user.id
    rescue
      response_access_denied
    end

    # check user access to run/stop all bots by account_id
    def check_access_control_account_all
      @account  = Account.find(params[:account_id])

      #response_access_denied unless current_user.has_role?(:admin) || current_user.id == @account.user_id
    rescue
      response_access_denied
    end

    def response_access_denied
      respond_to { |format| format.json { render :json => { :status => :error, :message => 'access denied' } } }
    end

end
