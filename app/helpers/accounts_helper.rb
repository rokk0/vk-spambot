module AccountsHelper

  private

    def check_user
      @user = User.find(params[:user_id])
    rescue
      flash_user_not_found
    end

    def check_account
      @account = Account.find(params[:id])
    rescue
      flash_account_not_found
    end

    # check user access to all information about accounts except listing.
    #def user_access
    #  @account = current_user.has_role?(:admin) ? Account.find(params[:id]) : current_user.accounts.find(params[:id])

    #  check_user_access(@account.user_id)

    #rescue
    #  flash_access_denied
    #end

    # check user access to create accounts.
    #def user_access_create
    #  check_user_access(params[:user_id])
    #end

    # check user access to actions with accounts, also return exception if user not found.
    #def check_user_access(user_id)
    #  user = User.find(user_id)

    #  flash_access_denied unless !user.has_role?(:admin) && current_user.has_role?(:admin) || current_user?(user)

    #rescue
    #  flash_user_not_found
    #  current_user
    #end

end
