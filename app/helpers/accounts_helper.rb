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

end
