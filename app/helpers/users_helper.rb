module UsersHelper

  def gravatar_for(user, options = { :size => 50 })
    gravatar_image_tag(user.email.downcase, :alt => user.name,
                                            :class => 'gravatar',
                                            :gravatar => options)
  end

  private

    def check_user
      @user = User.find(params[:id])
    rescue
      flash_user_not_found
    end

end