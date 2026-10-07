# frozen_string_literal: true

require 'rails_helper'
RSpec.describe DocumentsController, type: :controller do
  let(:member) { create(:member) }
  let(:category) { DocumentCategory.create!(title_no: 'Styret', title_en: 'Board') }
  let(:upload) { Rack::Test::UploadedFile.new(Rails.root.join('app/assets/files/strategi.pdf').to_s, 'application/pdf') }
  let(:document) { Document.create!(title: 'Strategy', category: category, uploader: member, file: upload) }
  before do
    member.roles << Role.super_user
    login_member(member)
  end
  %i[index admin].each do |action|
    it "lists categories with the board first for #{action}" do
      other = DocumentCategory.create!(title_no: 'Annet', title_en: 'Other')
      category
      get action
      expect(assigns(:categories)).to eq([category, other])
    end
  end
  it 'starts a new document' do
    get :new
    expect(assigns(:document)).to be_new_record
  end
  it 'loads a document for editing' do
    get :edit, params: { id: document.id }
    expect(assigns(:document)).to eq(document)
  end
  it 'saves uploads with the current member as uploader' do
    expect { post :create, params: { document: { title: 'Uploaded', category_id: category.id, file: upload } } }.to change(Document, :count).by(1)
    expect(assigns(:document).uploader).to eq(member)
    expect(response).to redirect_to(admin_documents_path)
  end
  it 'rejects a missing PDF' do
    expect { post :create, params: { document: { title: 'Missing file' } } }.not_to change(Document, :count)
    expect(response).to render_template(:new)
  end
  it 'updates document titles' do
    patch :update, params: { id: document.id, document: { title: 'Changed' } }
    expect(document.reload.title).to eq('Changed')
    expect(response).to redirect_to(admin_documents_path)
  end
  it 'deletes the requested document' do
    document
    expect { delete :destroy, params: { id: document.id } }.to change(Document, :count).by(-1)
    expect(response).to redirect_to(admin_documents_path)
  end
end
