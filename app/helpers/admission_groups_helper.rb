# frozen_string_literal: true

module AdmissionGroupsHelper
  # Path generator to allow both index and show action to act as active in template
  # see layout/admissions.html.haml for sample usage
  def my_group_path(admission, group)
    if group.nil?
      admissions_admin_admission_path(admission)
    else
      admissions_admin_admission_group_path(admission, group)
    end
  end

  # This method is used primarily in the interview table for showing the last n
  # log entries for an applicant.
  def interview_log_entries_list_text(admission, applicant, l)
    log_entries = applicant.log_entries_in_admission(admission)
    index = log_entries.index(l) + 1

    "Log \##{index}: #{l.log} (#{l.group.short_name})"
  end
end
