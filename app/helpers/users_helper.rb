module UsersHelper

  def gravatar_for(user, options = { :size => 50 })
    gravatar_image_tag(user.email.downcase, :alt => user.name,
                                            :class => 'gravatar',
                                            :gravatar => options)
  end

  private

    def authenticate
      deny_access unless signed_in?
    end

    def correct_user
      @user = User.find(params[:id])
      if (@user.admin? || !current_user.admin?) && !current_user?(@user)
        flash_access_denied
      end
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
 
    def check_user
      @user = User.find(params[:id])
    rescue
      flash_user_not_found
    end

end