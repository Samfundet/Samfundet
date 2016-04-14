# -*- encoding : utf-8 -*-
module GroupHelper
  def abbreviate_long_name(group, options = {})
    return if group.name.nil?

    options[:limit] ||= 30

    if group.name.length >= options[:limit]
      content_tag :abbr, html_escape(group.abbreviation), title: group.name
    else
      html_escape(group.name)
    end
  end

  def can_i_manage_admissions_for_at_least_one_group?()
    Group.all.each do |group|
      job = Job.new(group: group)
      job_application = JobApplication.new(job: job)
      job_interview = Interview.new(job_application: job_application)
      if permitted_to?(:manage, job) and
         permitted_to?(:manage, job_application) and
         permitted_to?(:manage, job_interview)
        return true
      end
    end
    return false
  end

  def group_link(group, options = {})
    render 'groups/link', group: group, options: options
  end
end
