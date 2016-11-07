module FixLocalesSpecs
  module ::ActionController::TestCase::Behavior
    alias_method :process_without_logging, :process

    def process(action, method = "SOMETHING", **args)
      if args.has_key?(:params)
        args[:params].merge!({locale: "en"})
      else
        args[:params] = {locale: "en"}
      end

      if method != "SOMETHING"
        args[:method] = method
      end
      process_without_logging(action, **args)
    end
  end
end
