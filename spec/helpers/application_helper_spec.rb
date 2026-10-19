# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  it 'sets and returns the page title' do
    expect(helper.set_and_return_title('Concert')).to eq('Concert')
    expect(helper.content_for(:title)).to eq('Concert')
  end
  it 'capitalizes translations while forwarding interpolation options' do
    expect(helper.T('example', default: 'hello %{name}', name: 'ola')).to eq('Hello ola')
  end
  it 'switches between English and Norwegian' do
    I18n.with_locale(:no) { expect(helper.change_language).to eq(locale: 'en') }
    I18n.with_locale(:en) { expect(helper.change_language).to eq(locale: 'no') }
  end
  it 'delegates language switches to a controller with custom routes' do
    controller.define_singleton_method(:change_language) { { id: 'translated', locale: 'en' } }
    expect(helper.change_language).to eq(id: 'translated', locale: 'en')
  end
  it 'escapes flash contents while rendering recognized flash types' do
    helper.flash[:error] = '<script>alert(1)</script>'
    helper.flash[:success] = 'Saved'
    expect(helper.display_flash(:error)).to include('class="flash error"', '&lt;script&gt;')
    expect(helper.display_flash).to include('Saved', 'flash success')
    expect(helper.display_flash(:warning)).to be_nil
  end
  it 'applies active classes only to the current page' do
    allow(helper).to receive(:current_page?).with('/current').and_return(true)
    allow(helper).to receive(:current_page?).with('/other').and_return(false)
    expect(helper.active_page_class('/current')).to eq(class: 'active')
    expect(helper.active_page_class('/current', 'selected')).to eq(class: 'selected')
    expect(helper.active_page_class('/other')).to eq({})
  end
  it 'places CSS in the head and JavaScript in the tail' do
    helper.stylesheet('https://example.com/style.css')
    helper.javascript('https://example.com/script.js')
    expect(helper.content_for(:head)).to include('style.css')
    expect(helper.content_for(:tail)).to include('script.js')
  end
  it 'renders the Typekit script and loader' do
    expect(helper.typekit_include_tag('abc')).to include('//use.typekit.net/abc.js', 'Typekit.load()')
  end
  it "lists only today's open areas" do
    travel_to Time.zone.local(2026, 10, 5, 18) do
      area = create(:area)
      open = StandardHour.create!(area: area, day: 'monday', open: true, open_time: '16:00', close_time: '22:00')
      StandardHour.create!(area: create(:area), day: 'monday', open: false)
      expect(helper.todays_standard_hours).to contain_exactly(open)
    end
  end
  it 'detects relevant control-panel applets' do
    allow(ControlPanel).to receive(:applets).with(helper.request).and_return([double(relevant?: false)])
    expect(helper.has_control_panel_applets?).to be(false)
    allow(ControlPanel).to receive(:applets).with(helper.request).and_return([double(relevant?: true)])
    expect(helper.has_control_panel_applets?).to be(true)
  end
  it 'builds absolute asset URLs' do
    allow(helper).to receive(:root_url).and_return('https://test.host/')
    allow(helper).to receive(:asset_path).with('logo.png').and_return('/assets/logo.png')
    expect(helper.asset_url('logo.png').to_s).to eq('https://test.host/assets/logo.png')
  end
end
