# frozen_string_literal: true

class AdmissionsAdminAbility
  include CanCan::Ability

  def initialize(user)
    @user = user

    if @user.is_a? Member
      @user.roles.each do |role|
        # Call method on self for every title, if exists.
        self.send(role.title) if self.respond_to?(role.title)
      end
    end
  end

  def lim_web
    # Nothing is beyond our reach
    can :manage, :all
  end

  def mg_nestleder
    # MG::Nestleder is responsible for the entire admission process of Samfundet.no
    # Remember that this is all within the context of the AdmissionAdmin controller namespace
    can :manage, [Admission, Applicant, Group, Interview, Job, JobApplication, LogEntry]
  end

  def opptaksansvarlig
    can :show, Admission
    can :show_interested_other_positions, Applicant
  end

  Group.all.each do |group|
    define_method(:"#{group.admission_responsible_role}") do
      opptaksansvarlig

      can [:show, :applications, :reject_calls], Group, id: group.id
      can [:new, :create, :search, :edit, :update, :show, :delete], Job, group_id: group.id
      can :show, JobApplication, job: { group: { id: group.id } }
      can [:show, :update], Interview, job_application: { job: { group: { id: group.id } } }
      can [:create, :destroy], LogEntry, group_id: group.id
    end

    define_method(:"#{group.group_leader_role}") do
      # A group_leader should have the same permissions as their admission_responsible
      send(group.admission_responsible_role)
    end
  end
end
