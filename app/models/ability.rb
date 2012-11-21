class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    if user.has_role?(:admin)
      can :manage, :all
    else
      can :manage, User,    :id => user.id
      can :manage, Account, :user_id => user.id
      can :manage, Bot,     :account => { :user => { :id => user.id } }

      cannot :index, User
      cannot :create, User
      cannot :destroy, User
      cannot :create, Account
      cannot :destroy, Account
      cannot :create, Bot

      can :create, Account do
        user.accounts.count < user.accounts_allowed
      end

      can :create, Bot do |bot|
        account_id = bot.account_id

        if account_id
          account = Account.find(account_id)
          permission = account.bots.count < account.bots_allowed
        else
          permission = user.bots.count < user.accounts.sum(:bots_allowed)
        end

        permission
      end
    end
  end
end
