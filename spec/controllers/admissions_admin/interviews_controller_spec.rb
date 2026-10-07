# frozen_string_literal: true

require 'rails_helper'
RSpec.describe AdmissionsAdmin::InterviewsController, type: :controller do
  let(:interview) { create(:interview) }
  let(:application) { interview.job_application }
  let(:ids) { { id: interview.id, job_application_id: application.id, job_id: application.job.id, group_id: application.job.group.id, admission_id: application.job.admission.id } }
  before do
    member = create(:member)
    member.roles << Role.super_user
    login_member(member)
  end
  it 'exports a thirty-minute interview as a calendar event' do
    get :show, params: ids, format: :ics
    events = Icalendar::Calendar.parse(response.body).first.events
    expect(events.size).to eq(1)
    expect(events.first.dtstart.to_time.to_i).to eq(interview.time.to_i)
    expect(events.first.dtend.to_time.to_i - events.first.dtstart.to_time.to_i).to eq(1800)
  end
  it 'rejects calendar export when no time is scheduled' do
    interview.update!(time: nil)
    expect { get :show, params: ids, format: :ics }.to raise_error(RuntimeError, 'No interview time set')
  end
  it 'updates interview time, location and comments' do
    time = 3.days.from_now.change(sec: 0, usec: 0)
    patch :update, params: ids.merge(interview: { time: time, location: 'Office', comment: 'Bring CV' })
    expect(interview.reload.time).to eq(time)
    expect(interview.location).to eq('Office')
    expect(interview.comment).to eq('Bring CV')
    expect(response).to be_redirect
  end
  it 'automatically rejects an applicant marked not wanted' do
    patch :update, params: ids.merge(interview: { priority: 'not_wanted' })
    expect(interview.reload.priority).to eq(:not_wanted)
    expect(interview.applicant_status).to eq(:rejected)
  end
  it 'sets a rejection priority when no priority has been assigned' do
    interview.update!(priority: nil)
    patch :update, params: ids.merge(interview: { applicant_status: 'rejected' })
    expect(interview.reload.applicant_status).to eq(:rejected)
    expect(interview.priority).to eq(:not_wanted)
  end
  it 'returns status JSON for AJAX updates' do
    patch :update, params: ids.merge(interview: { location: 'Office' }), xhr: true
    body = JSON.parse(response.body)
    expect(body['status']).to eq('this_job')
    expect(body['warning']).to be_nil
  end
  it 'warns about other interviews within thirty minutes' do
    other = create(:job_application, applicant: application.applicant)
    other.find_or_create_interview.update!(time: interview.time + 15.minutes)
    patch :update, params: ids.merge(interview: { location: 'Office' }), xhr: true
    expect(JSON.parse(response.body)['warning']).to be_present
  end
  it 'reports invalid priorities without changing the saved priority' do
    patch :update, params: ids.merge(interview: { priority: 'invalid' }), xhr: true
    expect(response).to have_http_status(:internal_server_error)
    expect(interview.reload.priority).to eq(:wanted)
  end
  it 'redirects with an error for invalid non-AJAX updates' do
    patch :update, params: ids.merge(interview: { priority: 'invalid' })
    expect(flash[:error]).to be_present
    expect(response).to be_redirect
  end
end
