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
    # A guest should be able to read basic stuff
    can :read, [Blog, Group, Page, Document]

    # Should be able to make a reservation @ Lyche
    can [:create, :success, :available], Sulten::Reservation

    can :execute, :graphql

    # Should be allowed to search
    can [:create, :search], Search

    # Admission
    can :read, Admission
    can :read, Job
    can :create, JobApplication

    ## A guest should be able to create an Applicant and forget its password
    can [:create,
         :forgot_password,
         :generate_forgot_password_email,
         :reset_password,
         :change_password], Applicant

    # Event stuff actions. This should probably be cleaned up
    can [:read, :buy, :ical,
         :archive, :archive_search,
         :purchase_callback_success,
         :purchase_callback_failure, :rss], Event

  end

  def medlem
    can :preview, Page
    can [:edit, :update], Page if role is_in { user.sub_roles }

    # A little but unsure about this one
    can :control_panel, Member

    # If the Role is passable and the current user is one of its current holders
    can :pass, Role, passable: true, members: contains { user }

    # A Member should be able to read and maage a Role if they are a part of it
    can [:read, :manage_members], Role, role_id: is_in { users.roles.pluck(:id) }

    # Should only be able to search members if they have a Role to pass
    can :search, Member if can? :pass, Role

    # If they can manage members of a role, they shold be able to manage MemberRole
    can :manage, MemberRole if can? :manage_members, Role
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
