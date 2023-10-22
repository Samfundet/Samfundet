# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    # Given user or an applicant
    @user = user

    # Everyone should be able to do guest stuff
    guest

    if @user.is_a? Member
      member

      # Does the user have any roles?
      if @user.roles.any?
        # The member has a role!
        member_has_role

        # If the member has any child roles
        member_has_child_roles if @user.child_roles.any?

        # Grant additional privileges if any of roles are passable
        member_passable_role if @user.roles.passable.any?

        # Grant permissions for the users roles AND child roles
        @user.sub_roles.each do |role|
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
    can [:index, :show], [Blog, Page, Document, Group, CrowdFundingSupporter]

    # Should be allowed to search
    can [:create, :search], Search

    # Admission
    can :index, Admission
    can :show, Job

    ## A guest should be able to create an Applicant and forget its password
    can [:create,
         :forgot_password,
         :generate_forgot_password_email,
         :reset_password,
         :change_password], Applicant

    # Event stuff actions. This should probably be cleaned up
    can [:index, :show, :buy, :ical, :search,
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

  def member
    # A little but unsure about this one
    can :control_panel, Member
  end

  def member_has_role
    # If the user has the Pages owner role, either directly or transitively
    can [:admin, :edit, :update, :preview], Page, role_id: @user.sub_roles.pluck(:id)
  end

  def member_has_child_roles
    # Can manage child roles so should be able to search members to add
    can :search, Member

    # Can manage a role IF the user has the parent role (role_id)
    can [:index, :show, :manage_members, :one_year_old], Role, role_id: @user.roles.pluck(:id)

    # Only allowed to add/remove user from role if
    # 1. the user has the assigned role as a child
    # 2. the user owns the parent role of the child role
    can [:create, :destroy], MembersRole, role: { id: @user.child_roles.pluck(:id), role_id: @user.roles.pluck(:id) }
  end

  def member_passable_role
    # Should only be able to search members if they have a Role to pass
    can :search, Member

    # If the Role is passable and the current user is one of its current holders
    can :pass, Role, passable: true, id: @user.roles.pluck(:id)
  end

  # MG

  def lim_web
    # Nothing is beyond our reach
    can :manage, :all
  end

  def mg_layout
    can :manage, [Event, Image, FrontPageLock]
  end

  def mg_redaksjon
    can :manage, [Blog, Event, Page, FrontPageLock, EverythingClosedPeriod, Area, Image, InfoBox]
  end

  # ORGANIZATION
  def styret
    can :manage, [Blog, Document, CrowdFundingSupporter, Image]
  end

  def raadet
    can :manage, Document
  end

  def fs
    can :manage, Document
  end

  def fs_fu
    can :manage, CrowdFundingSupporter
  end

  def mg_nestleder
    # Needs manage permissions here to see statistics
    can :manage, [Admission, JobApplication]
  end

  def gjengsjef; end

  def arrangementansvarlig
    can :manage, [Event, Image, FrontPageLock]
  end

  Group.all.each do |group|
    # If the method has not been defined yet. Prevent overriding of styret, fs and raadet methods
    if !self.method_defined? group.member_role
      define_method(:"#{group.member_role}") do
      end
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
