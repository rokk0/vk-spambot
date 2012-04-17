module BotsHelper

  private

    # check user access to all information about bots except listing.
    def user_access
      @bot = current_user.admin? ? Bot.find(params[:id]) : current_user.bots.find(params[:id])
      check_user_access(@bot.user_id)
    rescue
      flash_access_denied
    end

    # check user access to create bots.
    def user_access_create
      check_user_access(params[:user_id])
    end

    # check user access to run/stop bots.
    def user_access_control
      _bot = Bot.find(params[:id])
      if current_user.admin?
        @bot = !User.find(_bot.user_id).admin? ? _bot : current_user.bots.find(params[:id])
      else
        @bot = current_user.bots.find(params[:id])
      end
    rescue
      respond_to { |format| format.json { render :json => { 'state' => 'access denied' } } }
    end

    # check user access to actions with bots, also return exception if user not found.
    def check_user_access(user_id)
      user = User.find(user_id.to_i)
      flash_access_denied if !current_user?(user) && user.admin? && current_user.admin?
    rescue
      flash_user_not_found
    end

end
