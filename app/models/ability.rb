class Ability
  include CanCan::Ability

  def initialize(user)
    if user.nil? # user is guest
      can :read, Blog

    elsif user.roles.name == 'member'
      can :read, Blog
      can :mangage, Blog, author_id: user.id

    else user.roles.name == 'lim_web'
      can :manage, :all
    end
  end
end
