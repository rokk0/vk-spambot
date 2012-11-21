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

  def link_with_icon(title, url, icon, *args)
    link_to raw("<i class='icon-#{icon}'></i> #{title}"), url, *args
  end

  def ratio_title(type)
    title = t "header.#{type.to_s}"

    ratio = case type
    when :bots
      "#{current_user.bots.count}/#{current_user.accounts.sum(:bots_allowed)}"
    when :accounts
      "#{current_user.accounts.count}/#{current_user.accounts_allowed}"
    else
      raise "ApplicationHelper#ratio_title: 'type' must be :bots or :accounts"
    end

    "#{title} (#{ratio})"
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
