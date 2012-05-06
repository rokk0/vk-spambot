module AccountsHelper

  private

    # check user access to all information about accounts except listing.
    def user_access
      @account = current_user.admin? ? Account.find(params[:id]) : current_user.accounts.find(params[:id])

      check_user_access(@account.user_id)

    rescue
      flash_access_denied
    end

    # check user access to create accounts.
    def user_access_create
      check_user_access(params[:user_id])
    end

    # check user access to actions with accounts, also return exception if user not found.
    def check_user_access(user_id)
      user = User.find(user_id)

      flash_access_denied unless !user.admin? && current_user.admin? || current_user?(user)

    rescue
      flash_user_not_found
    end

end
