module ApplicationHelper

  # Return a title on a per-page basis.
  def title
    base_title = "VK spambot"
    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title}"
    end
  end

  def flash_access_denied
    flash.now[:error] = 'Access denied.'
    render 'shared/_error_messages'
  end

  def flash_user_not_found
    flash.now[:error] = 'User not found.'
    render 'shared/_error_messages'
  end

  def flash_account_not_found
    flash.now[:error] = 'VK account not found.'
    render 'shared/_error_messages'
  end

  def flash_bot_not_found
    flash.now[:error] = 'Bot not found.'
    render 'shared/_error_messages'
  end

end
