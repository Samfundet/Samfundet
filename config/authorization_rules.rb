# -*- encoding : utf-8 -*-
authorization do
  role :guest do
    # Login is not protected, and should not be!
    has_permission_on :applicant_sessions, to: :create
    has_permission_on :member_sessions, to: :create
    has_permission_on :user_sessions, to: :create

    # Search
    has_permission_on :search, to: [:create, :search]

    # Password reset should not be protected.
    has_permission_on :applicants,
      to: [:forgot_password,
        :generate_forgot_password_email,
        :reset_password,
        :change_password]

    # Explicit read-privileges
    has_permission_on :site, to: :read
    has_permission_on :admissions, to: :read
    has_permission_on :jobs, to: :read
    has_permission_on :job_applications, to: :create
    has_permission_on :groups, to: :read
    has_permission_on :blogs, to: :read
    has_permission_on :contact, to: [:index, :create]

    # Explicit create-privileges
    has_permission_on :applicants, to: :create

    # Explicit read-privileges
    has_permission_on :documents, to: :index
    has_permission_on :pages, to: :read

    # Explicit read- and buy-privileges
    has_permission_on :events, to: [:read, :buy, :ical, :archive, :archive_search]

    has_permission_on :sulten_reservations, to: [:create, :success, :available]
  end

  role :medlem do
    includes :guest

    has_permission_on :user_sessions, to: :destroy

    has_permission_on :members, to: :control_panel

    has_permission_on :members, to: :search do
      if_permitted_to :pass, :roles
    end
    # kommentere på events osv.
    # kommer seff etterhvert :)
    #
    # denne permissionen på sider vil vi etterhvert flytte over til en egen
    # page_admin rolle, en slags redaktør.
    has_permission_on :pages, to: :preview
    has_permission_on :pages, to: [:edit, :update] do
      if_attribute role: is_in {user.sub_roles}
    end

    has_permission_on :roles, to: :pass do
      if_attribute passable: true,
        members: contains { user }
    end

    has_permission_on :roles, to: [:read, :manage_members] do
      if_attribute role_id: is_in { user.roles.select(:id) }
    end

    has_permission_on :members_roles, to: :manage do
      if_permitted_to :manage_members, :role
    end
  end

  role :ksg_sulten do
    has_permission_on [
      :sulten_tables,
      :sulten_reservations,
      :sulten_reservation_types,
      :sulten_admin
      ], to: :manage
  end

  role :lim_web do
    # EVERYTHING!
    has_permission_on :authorization_rules, to: :read
    has_permission_on :authorization_usages, to: :read

    has_permission_on [
      :admissions,
      :admissions_admin_admissions,
      :admissions_admin_groups,
      :admissions_admin_interviews,
      :admissions_admin_jobs,
      :admissions_admin_job_applications,
      :admissions_admin_log_entries,
      :admissions_admin_applicants,
      :applicants,
      :applicant_sessions,
      :areas,
      :blogs,
      :documents,
      :events,
      :everything_closed_periods,
      :front_page_locks,
      :groups,
      :images,
      :jobs,
      :job_applications,
      :members_roles,
      :member_sessions,
      :pages,
      :roles,
      :user_sessions,
      :sulten_tables,
      :sulten_reservations,
      :sulten_reservation_types,
      :sulten_admin,
      :contact,
      :admissions_admin_campus
      ], to: :manage

    has_permission_on :admissions_admin_groups, to: :reject_calls
    has_permission_on :roles, to: :one_year_old
    has_permission_on :admissions_admin_campus, to: [:activate, :deactivate]
    has_permission_on :admissions_admin_job_applications, to: [:hidden_create, :withdraw_job_application]
    has_permission_on :admissions_admin_jobs, to: :hidden_create
    has_permission_on :admissions_admin_admissions, to: :statistics
    has_permission_on :admissions_admin_groups, to: :applications
    has_permission_on :admissions_admin_applicants, to: :show_interested_other_positions
    has_permission_on [:members, :applicants], to: :steal_identity
    has_permission_on :members, to: :search

    has_permission_on :roles, to: :manage_members

    has_permission_on :pages, to: [:new, :create, :destroy, :edit_non_content_fields, :graph, :history]
  end

  role :mg_nestleder do
    has_permission_on [
      :admissions,
      :admissions_admin_admissions,
      :admissions_admin_groups,
      :admissions_admin_interviews,
      :admissions_admin_jobs,
      :admissions_admin_job_applications,
      :admissions_admin_log_entries,
    ], to: :manage

    has_permission_on :admissions_admin_job_applications, to: [:hidden_create, :withdraw_job_application]
    has_permission_on :job_applications, to: [:update, :delete]
    has_permission_on :admissions_admin_jobs, to: :hidden_create
    has_permission_on :admissions_admin_groups, to: [:applications, :reject_calls]
    has_permission_on :admissions_admin_admissions, to: :statistics
  end

  role :soker do
    includes :guest

    has_permission_on :user_sessions, to: :destroy

    has_permission_on :job_applications, to: [:manage, :down, :up] do
      if_attribute applicant: is { user }
    end
    has_permission_on :applicants, to: [:update] do
      if_attribute id: is {user.id}
    end
  end

  role :opptaksansvarlig do
    has_permission_on :admissions_admin_admissions, to: :show
    has_permission_on :admissions_admin_applicants, to: [:update, :show_interested_other_positions]
  end

  role :gjengsjef do
    has_permission_on :roles, to: :one_year_old
  end

  role :arrangementansvarlig do
    has_permission_on :events, to: :manage
    has_permission_on :front_page_locks, to: :manage
    has_permission_on :images, to: [:read]
  end

  role :mg_layout do
    has_permission_on :events, to: :manage
    has_permission_on :front_page_locks, to: :manage
    has_permission_on :images, to: :manage
  end

  role :mg_redaksjon do
    has_permission_on [
      :areas,
      :events,
      :pages,
      :blogs,
      :everything_closed_periods
    ], to: :manage

    has_permission_on :pages, to: [:read, :update]
  end

  [:fs, :raadet, :styret].each do |group_role|
    role group_role do
      has_permission_on :documents, to: :manage
    end
  end

  role :styret do
    has_permission_on :blogs, to: :manage
  end

  Group.all.each do |group|
    role group.group_leader_role do
      has_permission_on :groups, to: :update do
        if_attribute id: is { group.id }
      end
      includes :gjengsjef
      includes group.admission_responsible_role
    end

    role group.event_manager_role do
      includes :arrangementansvarlig
      includes group.member_role
    end

    role group.admission_responsible_role do
      includes :opptaksansvarlig
      includes group.member_role
      has_permission_on :admissions_admin_groups, to: [:show, :applications, :reject_calls] do
        if_attribute id: is { group.id }
      end
      has_permission_on :admissions_admin_jobs, to: [:new, :create, :search, :edit, :update, :show, :delete] do
        if_attribute group_id: is { group.id }
      end
      has_permission_on :admissions_admin_job_applications, to: :show do
        if_attribute job: { group: { id: is { group.id } } }
      end
      has_permission_on :admissions_admin_interviews, to: [:show, :update] do
        if_attribute job_application: { job: { group: { id: is { group.id } } } }
      end
      has_permission_on :admissions_admin_log_entries, to: [:create, :destroy] do
        if_attribute group_id: is { group.id }
      end
    end
  end

  role :mg_layout_sjef do
    includes :mg_layout
  end

  role :mg_gjengsjef do
    includes :mg_redaksjon
    includes :mg_layout_sjef
  end
end

privileges do
  # default privilege hierarchies to facilitate RESTful Rails apps
  privilege :manage, includes: [:create, :read, :update, :delete, :clear]
  privilege :read,   includes: [:index, :show, :search]
  privilege :create, includes: :new
  privilege :update, includes: :edit
  privilege :delete, includes: :destroy
end
