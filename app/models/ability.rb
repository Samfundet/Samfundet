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
    can :read, Page
    can :read, Blog
    can :read, Group
    can :read, Page
    can :read, Document

    # Should be able to make an reservation @ Lyche
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
