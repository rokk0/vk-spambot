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

      can :create, Bot do
        user = User.find(user.id)
        account = user.accounts.first
        account.bots.count < account.bots_allowed
      end

      #can :create, Account do
      #  user = User.find(user.id)
      #  require 'pp'
      #  pp "user.accounts.count: #{user.accounts.count}"
      #  pp "user.accounts_allowed: #{user.accounts_allowed}"
      #  pp user.accounts.count < user.accounts_allowed
      #  user.accounts.count < user.accounts_allowed
      #end

      cannot :index, User
      cannot :create, User
      cannot :destroy, User
      cannot :destroy, Account
    end
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.has_role?(:admin)
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user permission to do.
    # If you pass :manage it will apply to every action. Other common actions here are
    # :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. If you pass
    # :all it will apply to every resource. Otherwise pass a Ruby class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
