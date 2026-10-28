# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Exception notification configuration' do
  let(:configuration) { double('notifier configuration') }
  let(:notifiers) { {} }

  before do
    allow(ExceptionNotification).to receive(:configure).and_yield(configuration)
    allow(configuration).to receive(:add_notifier) do |name, options|
      notifiers[name] = options
    end
  end

  def load_configuration(environment)
    allow(Rails).to receive(:env).and_return(ActiveSupport::StringInquirer.new(environment))
    load Rails.root.join('config/initializers/exception_notification.rb')
  end

  it 'does not register external notifiers in development' do
    expect(configuration).not_to receive(:add_notifier)
    load_configuration('development')
  end

  %w[production staging].each do |environment|
    context "in #{environment}" do
      before { load_configuration(environment) }

      it 'builds an exception email with the configured sender, recipient and error details' do
        notifier = ExceptionNotifier::EmailNotifier.new(notifiers.fetch(:email).deep_dup)
        exception = RuntimeError.new('verification failed')
        exception.set_backtrace(['app/mailers/verify_email_applicant_mailer.rb:12:in `mail`'])
        mail = notifier.create_email(exception).message

        expect(mail.from).to eq(['mg-web@samfundet.no'])
        expect(mail.to).to eq(['mg-web-error@samfundet.no'])
        expect(mail.subject).to start_with('[ERROR] ')
        expect(mail.subject).to include('RuntimeError', 'verification failed')
        expect(mail.body.decoded).to include('verification failed', 'verify_email_applicant_mailer.rb:12')
        expect(notifiers.fetch(:email)[:sections]).to eq(%w[request backtrace])
      end

      it 'renders request exceptions with the configured request and backtrace sections' do
        notifier = ExceptionNotifier::EmailNotifier.new(notifiers.fetch(:email).deep_dup)
        exception = RuntimeError.new('request failed')
        exception.set_backtrace(['app/controllers/applicants_controller.rb:12:in `create`'])
        env = Rack::MockRequest.env_for('https://samfundet.no/applicants')
        mail = notifier.create_email(exception, env: env).message

        expect(mail.body.decoded).to include('/applicants', 'applicants_controller.rb:12', 'request failed')
      end

      it 'configures Slack with the webhook from the environment' do
        allow(ENV).to receive(:[]).and_call_original
        allow(ENV).to receive(:[]).with('SLACK_WEBHOOK_URL').and_return('https://example.test/slack')
        load_configuration(environment)

        expect(notifiers.fetch(:slack)).to eq(
          webhook_url: 'https://example.test/slack',
          additional_parameters: { color: '#A03033' }
        )
      end
    end
  end
end
