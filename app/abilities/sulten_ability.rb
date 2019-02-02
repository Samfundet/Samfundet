class SultenAbility
  include CanCan::Ability

  def initialize(user)
    # Given user or an applicant
    @user = user

    # Everyone should be able to do guest stuff
    guest

    if @user.is_a? Member
      @user.roles.each do |role|
        # Call method on self for every title, if it exists
        self.send(role.title) if self.respond_to? role.title
      end
    end
  end

  def guest
    # Should be able to make a reservation @ Lyche
    can [:create, :success, :available], Sulten::Reservation
  end

  def lim_web
    # Nothing is beyond our reach
    can :manage, :all
  end

  def ksg_sulten
    can :manage, [Sulten::Table, Sulten::Reservation, Sulten::ReservationType]
  end
end
