# -*- encoding : utf-8 -*-
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
end
