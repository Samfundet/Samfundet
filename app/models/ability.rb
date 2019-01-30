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

    can :execute, :graphql

    # Event stuff actions
    can [:read, :buy, :ical, :archive, :archive_search, :purchase_callback_success, :purchase_callback_failure, :rss], Event

  end

  def arrangementansvarlig
    can :manage, Event
  end

  def mg_layout
    can :manage, Event
  end

  def mg_redaksjon
    can :manage, [Blog, Event]
  end

  def styret
    can :manage, Blog
  end

  def lim_web
    # Nothing is beyond our reach
    can :manage, :all
  end
end
