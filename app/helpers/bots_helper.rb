module BotsHelper

  # check user access to actions with bots, also return exception if user not found.
  def user_bot_helper(user_id)
    user = User.find(user_id)
    flash_access_denied if !current_user?(user) && user.admin? && current_user.admin?
  rescue
    flash_user_not_found
  end

  def flash_access_denied
    flash.now[:error] = 'Access denied.'
    render 'error'
  end

  def flash_user_not_found
    flash.now[:error] = 'User not found.'
    render 'error'
  end
end
