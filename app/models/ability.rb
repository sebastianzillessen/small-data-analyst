class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    alias_action :create, :read, :update, :destroy, :index, :to => :crud
    alias_action :create, :update, :destroy, :to => :cud


    if user.is_admin?
      can :manage, :all
    end
    if user.is_statistician?
      can :crud, Analysis
      can :crud, Assumption
      can :crud, ResearchQuestion
      can :read, Dataset
      can :crud, Preference
      can :edit_global, Preference
    end

    if user.is_clinician?
      can :crud, Analysis, :user_id => user.id
      can :read, Model
      can :read, Assumption
      # can read all non private research questions
      can :read, ResearchQuestion, private: false
      can :read, ResearchQuestion, private: nil
      # can read all user owned private research questions
      can :read, ResearchQuestion, private: true, user_id: user.id
      # can update/delete all user-owned research questions
      can :cud, ResearchQuestion, :user_id => user.id
      can :crud, ResearchQuestion, :user_id => user.id
      can :crud, Preference, :user_id => user.id
      can :read, Preference
      can :crud, Dataset, user_id: user.id
      can :crud, QueryAssumptionResult do |qar|
        qar.analysis.user_id == user.id
      end
    end
  end
end