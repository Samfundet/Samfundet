# frozen_string_literal: true

require 'rails_helper'
RSpec.describe FrontPageLocksController, type: :controller do
  before do
    member = create(:member)
    member.roles << Role.super_user
    login_member(member)
  end
  it 'creates a slot lazily for editing' do
    get :edit, params: { id: 1 }
    expect(assigns(:front_page_lock).position).to eq(1)
    expect(assigns(:front_page_lock)).to be_persisted
    expect(assigns(:upcoming_events)).to be_empty
  end
  it 'pins an event and clears it again' do
    lock = FrontPageLock.create!(position: 1)
    event = create(:event)
    patch :update, params: { id: 1, front_page_lock: { lockable_type: 'Event', event_id: event.id } }
    expect(lock.reload.lockable).to eq(event)
    expect(response).to redirect_to(root_path)
    post :clear, params: { id: 1 }
    expect(lock.reload.lockable).to be_nil
  end
  it 'pins blog articles in a slot' do
    lock = FrontPageLock.create!(position: 2)
    blog = create(:blog, author: create(:member), image: create(:image))
    patch :update, params: { id: 2, front_page_lock: { lockable_type: 'Blog', blog_id: blog.id } }
    expect(lock.reload.lockable).to eq(blog)
  end
  it 'renders an error for an event that does not exist' do
    FrontPageLock.create!(position: 1)
    patch :update, params: { id: 1, front_page_lock: { lockable_type: 'Event', event_id: -1 } }
    expect(response).to render_template(:edit)
    expect(assigns(:front_page_lock).errors[:event_id]).to be_present
  end
end
