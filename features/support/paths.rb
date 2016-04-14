# -*- encoding : utf-8 -*-
module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    case page_name

    when /the home\s?page/
      '/'
    when /the login page/
      login_path
    when /the steal identity page/
      steal_identity_path
    when /the member login page/
      members_login_path
    when /the roles page/
      roles_path
    when /the role page for "([^"]+)"/
      role_path(Role.find_by_title($1))
    when /the groups page/
      groups_path
    when /the new group page/
      new_group_path
    when /the admissions page/
      admissions_path
    when /the new admission page/
      new_admission_path
    when /the new applicant page/
      new_applicant_path
    when /the applicant login page/
      applicants_login_path
    when /^(.+)'s applications page/
      job_applications_path
    when /the members control panel page/
      members_control_panel_path
    when /the applicant admission page for "([^"]+)"/
      group = Group.find_by_name($1)
      group_job_applications_path(group)
    when /the group page for "([^"]*)"/
      group_path(Group.find_by_name($1))
    when /the edit group page for "([^"]*)"/
      edit_group_path(Group.find_by_name($1))
    when /the job page for "([^"]*)" in "([^"]*)"/
      admissions_admin_admission_group_path(Admission.find_by_title($2), Group.find_by_name($1))
    when /the edit job page for "([^"]*)"/
      job = Job.find_by_title_no($1)
      group = job.group
      admission = job.admission
      edit_admissions_admin_admission_group_job_path(admission, group, job)
    when /the job page for "([^"]*)"/
      job_path(Job.find_by_title_no($1))
    when /the group interviews page for "([^"]*)" in "([^"]+)"/
      admissions_admin_admission_group_path(Admission.find_by_title($2), Group.find_by_name($1))
    when /([\w ]*)'s job application page for "([^"]*)"/
      firstname, surname = $1.split(" ")
      a = Applicant.find_by_firstname_and_surname(firstname, surname)
      job_application = JobApplication.find_by_applicant_id_and_job_id(a.id, Job.find_by_title_no($2).id)

      job = job_application.job
      group = job.group
      admission = job.admission
      admissions_admin_admission_group_job_job_application_path(admission, group, job, job_application)
    else
      raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
            "Now, go and add a mapping in #{__FILE__}"
    end
  end
end

World(NavigationHelpers)
