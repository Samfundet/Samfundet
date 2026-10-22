# frozen_string_literal: true

require 'rails_helper'
RSpec.describe ControlPanel do
  it 'evaluates applet visibility in controller context' do
    controller = double('controller')
    controller.define_singleton_method(:can_manage?) { true }
    applet = ControlPanel::Applet.new(controller, :admin, if: -> { can_manage? })
    expect(applet.relevant?).to be(true)
    expect(ControlPanel::Applet.new(controller, :admin, {}).relevant?).to be(true)
  end
  it 'prepares the applet and renders its partial as safe HTML' do
    controller = double('controller')
    expect(controller).to receive(:admin)
    expect(controller).to receive(:render_to_string).with(partial: 'admin').and_return('<p>Admin</p>')
    content = ControlPanel::Applet.new(controller, :admin, {}).render
    expect(content).to eq('<p>Admin</p>')
    expect(content).to be_html_safe
  end
  it 'collects applets from namespaced and top-level controllers' do
    request = ActionDispatch::TestRequest.create
    applets = ControlPanel.applets(request)
    expect(applets).not_to be_empty
    expect(applets).to all(be_a(ControlPanel::Applet))
  end
end
