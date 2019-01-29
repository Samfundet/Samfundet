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
    can :read, Blog
  end

  def lim_web
    puts @user.full_name
    can :manage, :all
  end
end
