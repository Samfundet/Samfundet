# -*- encoding : utf-8 -*-

module ModelHelpers
  def create_admission(opts = {})
    opts[:title]                       ||= "Admission"
    opts[:shown_from]                  ||= Time.current
    opts[:shown_application_deadline]  ||= opts[:shown_from] + 1.week
    opts[:actual_application_deadline] ||= opts[:shown_application_deadline] + 4.hours
    opts[:user_priority_deadline]      ||= opts[:shown_application_deadline] + 2.weeks
    opts[:admin_priority_deadline]     ||= opts[:user_priority_deadline] + 1.hour

    admission = Admission.create!(opts)
  end

  def create_open_admission(title = "Open admission")
    create_admission(
      title: title,
      shown_from: 1.hour.ago,
      shown_application_deadline: 1.week.from_now,
      actual_application_deadline: 1.week.from_now + 4.hours,
      user_priority_deadline: 2.weeks.from_now,
      admin_priority_deadline: 2.weeks.from_now + 1.hour
    )
  end

  def create_open_admissions(titles = [])
    titles.map { |title| create_open_admission title }
  end

  def create_upcoming_admission(title = "Upcoming admission")
    create_admission(
      title: title,
      shown_from: 2.hours.from_now,
      shown_application_deadline: 1.week.from_now,
      actual_application_deadline: 1.week.from_now + 4.hours,
      user_priority_deadline: 2.weeks.from_now,
      admin_priority_deadline: 2.weeks.from_now + 1.hour
    )
  end

  def create_upcoming_admissions(titles = [])
    titles.map { |title| create_upcoming_admission title }
  end

  def create_closed_admission(title = "Closed admission")
    create_admission(
      title: title,
      shown_from: 5.weeks.ago,
      shown_application_deadline: 5.weeks.ago + 1.week,
      actual_application_deadline: 5.weeks.ago + 1.week + 4.hours,
      user_priority_deadline: 5.weeks.ago + 2.weeks,
      admin_priority_deadline: 5.weeks.ago + 2.weeks + 1.hour
    )
  end

  def create_closed_admissions(titles = [])
    titles.map { |title| create_closed_admission title }
  end

  def create_group(name)
    type = GroupType.find_or_create_by_description("Dummy group type")
    Group.create!(name: name, group_type: type)
  end

  def create_groups(names)
    names.map { |name| create_group name }
  end

  def create_role(title)
    Role.create!(title: title,
                 name: "Dummy name",
                 description: "Dummy description.")
  end

  def create_roles(titles)
    titles.map { |title| create_role title }
  end

  def create_group_type(description)
    GroupType.create!(description: description)
  end

  def create_job(title, group, admission)
    Job.create!(
      admission: admission,
      title_no: title,
      teaser_no: "Dummy teaser",
      description_no: "Dummy description",
      group: group)
  end

  def create_member(firstname, surname)
    Member.create!(
      fornavn: firstname,
      etternavn: surname,
      mail: "#{firstname}@domain.no",
      telefon: "12 34 56 78",
      passord: "hunter2"
    )
  end

  def create_members_role(member, role)
    MembersRole.create!(
      member: member,
      role: role
    )
  end

  def create_applicant(params = {})
    params[:firstname]             ||= "John"
    params[:surname]               ||= "Doe"
    params[:email]                 ||= "applicant@example.com"
    params[:password]              ||= "password"
    params[:phone]                 ||= "12345678"

    params[:password_confirmation] = params[:password]

    Applicant.create!(params)
  end

  def create_job_application(job, applicant)
    JobApplication.create!(
      job: job,
      applicant: applicant,
      motivation: "Sample motivation"
    )
  end
end
