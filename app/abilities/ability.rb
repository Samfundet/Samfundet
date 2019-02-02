class Ability
  include CanCan::Ability

  def initialize(user)
    # Given user or an applicant
    @user = user

    # Everyone should be able to do guest stuff
    guest

    if @user.is_a? Member
      medlem

      # Does the user have any roles?
      if @user.roles.any?
        medlem_has_role

        # Grant additional privileges if any of roles are passable
        medlem_passable_role if @user.roles.passable.any?

        @user.roles.each do |role|
          # Call method on self for every title, if it exists.
          self.send(role.title) if self.respond_to? role.title
        end
      end
    elsif @user.is_a? Applicant
      soker
    end
  end

  def guest
    # A guest should be able to show basic stuff
    can [:index, :show], [Blog, Page, Document]

    # Should be able to make a reservation @ Lyche
    can [:create, :success, :available], Sulten::Reservation

    can :execute, :graphql

    # Should be allowed to search
    can [:create, :search], Search

    # Admission
    can [:index, :show], Admission
    can :show, Job
    can :create, JobApplication

    ## A guest should be able to create an Applicant and forget its password
    can [:create,
         :forgot_password,
         :generate_forgot_password_email,
         :reset_password,
         :change_password], Applicant

    # Event stuff actions. This should probably be cleaned up
    can [:index, :show, :buy, :ical,
         :archive, :archive_search,
         :purchase_callback_success,
         :purchase_callback_failure, :rss], Event

  end

  def soker
    # Our lovely sokere should be able to manage their job applications
    can [:index, :create, :update, :destroy, :down, :up], JobApplication, applicant: { id: @user.id }

    # And to update their user
    can :update, Applicant, id: @user.id
  end

  def medlem
    # If the user has the Pages owner role
    can [:admin, :edit, :update, :preview], Page, role_id: @user.sub_roles.pluck(:id)

    # A little but unsure about this one
    can :control_panel, Member
  end

  def medlem_has_role
    # A Member should be able to show and manage a Role if they are a part of it
    can [:index, :show, :manage_members], Role, role_id: @user.roles.pluck(:id)

    # If they can manage members of a role, they shold be able to manage MembersRole
    can :manage, MembersRole if can? :manage_members, Role
  end

  def medlem_passable_role
    # Should only be able to search members if they have a Role to pass
    can :search, Member

    # If the Role is passable and the current user is one of its current holders
    can :pass, Role, id: @user.roles.pluck(:id)
  end

  # MG

  def lim_web
    # Nothing is beyond our reach
    can :manage, :all
  end

  def mg_layout
    can :manage, Event
  end

  def mg_redaksjon
    can :manage, [Blog, Event]
  end

  # ORGANIZATION
  def styret
    can :manage, Blog
  end

  def gjengsjef
    can :one_year_old, Role
  end

  def arrangementansvarlig
    can :manage, Event
  end

  Group.all.each do |group|
    define_method(:"#{group.member_role}") do
    end

    define_method(:"#{group.event_manager_role}") do
      arrangementansvarlig
    end

    define_method(:"#{group.group_leader_role}") do
      # Can only update its own group
      can [:admin, :edit, :update], Group, id: group.id

      # Call gjengsjef and generated method
      gjengsjef
    end
  end
end
