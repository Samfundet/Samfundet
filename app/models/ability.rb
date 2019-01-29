class Ability
  include CanCan::Ability

  def initialize(user)
    # Given user or a guest
    @user = user || Member.new

    @user.roles.each{|role| send(role.title)}

    # Everyone is a guest!
    guest
  end

  def guest
    # Read the index page
    can :read, :site
    can :read, Blog
  end

  def mg_redaksjon
    can :manage, Blog
  end

  def styret
    can :manage, Blog
  end

  def lim_web
    # Everything. Manage is a wild card that matches anything
    can :manage, :all
  end
end
