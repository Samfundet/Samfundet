# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Sendmail configuration' do
  %w[production staging].each do |environment|
    it "builds the delivery adapter with the #{environment} settings" do
      # Evaluate the actual environment configuration without booting another
      # environment or changing the running test application's settings.
      configuration = ActiveSupport::OrderedOptions.new
      %i[action_controller action_view active_support public_file_server assets action_mailer].each do |key|
        configuration[key] = ActiveSupport::OrderedOptions.new
      end
      allow(configuration).to receive(:after_initialize)
      context = double('configuration context', config: configuration)
      allow(Samfundet::Application).to receive(:configure) do |&block|
        context.instance_exec(&block)
      end
      allow(ActiveSupport::Logger).to receive(:new)
      allow(Member).to receive(:establish_connection)
      allow(Member).to receive(:table_name=)
      allow(Paperclip).to receive(:options).and_return(Paperclip.options.dup)

      load Rails.root.join("config/environments/#{environment}.rb")

      mail = Mail.new
      mail.delivery_method(configuration.action_mailer.delivery_method,
                           configuration.action_mailer.sendmail_settings)

      expect(mail.delivery_method).to be_a(Mail::Sendmail)
      expect(mail.delivery_method.settings[:arguments]).to eq(['-i'])
    end
  end
end
