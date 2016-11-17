# frozen_string_literal: true
module FixLocalesSpecs
  module ::ActionController::TestCase::Behavior
    alias process_without_logging process

    def process(action, method = 'SOMETHING', **args)
      if args.key?(:params)
        args[:params][:locale] = 'en'
      else
        args[:params] = { locale: 'en' }
      end

      args[:method] = method if method != 'SOMETHING'
      process_without_logging(action, **args)
    end
  end
end
