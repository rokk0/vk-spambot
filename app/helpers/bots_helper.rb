module BotsHelper

  # check user access to actions with bots, also return exception if user not found.
  def user_bot_helper(user_id)
    user = User.find(user_id.to_i)
    flash_access_denied if !current_user?(user) && user.admin? && current_user.admin?
  rescue
    flash_user_not_found
  end

  def flash_access_denied
    flash.now[:error] = 'Access denied.'
    render 'shared/_error_messages'
  end

  def flash_user_not_found
    flash.now[:error] = 'User not found.'
    render 'shared/_error_messages'
  end
end
