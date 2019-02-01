class Ability
  include CanCan::Ability

  def initialize(user)
    # Given user or a guest
    @user = user || Member.new

    # Everyone is a guest!
    guest

    if @user.is_a? Member
      medlem
      @user.roles.each{|role| send(role.title)}
    elsif @user.is_a? Applicant
      soker
    end
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

  def soker
    # Our lovely sokere should be able to manage their job applications
    can [:manage, :down, :up], JobApplication, applicant: { id: @user.id }

    # And to update their user
    can :update, Applicant, id: @user.id
  end

  def medlem
    # A member is almost identical to a guest, unless they have an additional

    # If the user has the Pages owner role
    can [:admin, :edit, :update, :preview], Page, role_id: @user.sub_roles.pluck(:id)

    # A little but unsure about this one
    can :control_panel, Member

    # If the Role is passable and the current user is one of its current holders
    can :pass, Role, passable: true, id: @user.roles.pluck(:id)

    # A Member should be able to read and maage a Role if they are a part of it
    can [:read, :manage_members], Role, role_id: @user.sub_roles.pluck(:id)

    # Should only be able to search members if they have a Role to pass
    can :search, Member if can? :pass, Role

    # If they can manage members of a role, they shold be able to manage MemberRole
    can :manage, :member_role if can? :manage_members, Role
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

  def opptaksansvarlig
    can :show, :admissions_admin_admissions
    can [:update, :show_interested_other_positions], :admissions_admin_applicants
  end


  Group.all.each do |group|

    define_method(:"#{group.event_manager_role}") do
      arrangementansvarlig
    end

    define_method(:"#{group.admission_responsible_role}") do
      opptaksansvarlig

      can [:show, :applications, :reject_calls], :admissions_admin_groups, id: group.id
      can [:new, :create, :search, :edit, :update, :show, :delete], :admissions_admin_jobs, group_id: group.id
      can :show, :admissions_admin_job_applications, job: { group: { id: group.id } }
      can [:show, :update], :admissions_admin_interviews, job_application: { job: { group: { id: group.id } }}
      can [:create, :destroy], :admissions_admin_log_entries, group_id: group.id
    end

    define_method(:"#{group.group_leader_role}") do
      # Can only update its own group
      can :update, Group, id: group.id

      # Call gjengsjef and generated method
      gjengsjef
      send(group.admission_responsible_role)
    end
  end
end
