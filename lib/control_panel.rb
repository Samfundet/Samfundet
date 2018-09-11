# frozen_string_literal: true

module ControlPanel
  class Applet
    def initialize(controller, action_name, options)
      @controller = controller
      @action_name = action_name
      @condition_block = options[:if] || -> { true }
    end

    def relevant?
      # uses instance_exec because instance_eval tries to pass self as a
      # parameter, so lambdas without arguments complain when using
      # instance_eval
      @controller.instance_exec(&@condition_block)
    end

    def render
      @controller.send(@action_name)

      # the string returned by render_to_string is always html safe, but
      # for some reason rails doesn't mark it as such
      @controller.render_to_string(partial: @action_name.to_s).html_safe
    end
  end

  module ControllerHelpers
    def control_panel_applets
      @control_panel_applets ||= []
    end

    def has_control_panel_applet(*args)
      control_panel_applets << lambda do |request|
        controller = new

        # need to pass the current request to the controller for the applet,
        # otherwise link_to breaks and declarative_authorization misbehaves
        controller.request = request

        Applet.new(controller, *args)
      end
    end
  end

  class << self
    def applets(request)
      Dir[Rails.root.join('app', 'controllers', '{[!api]**/*,*}_controller.rb')].flat_map do |path|
        controller_from_path(path).control_panel_applets.map do |create_applet|
          create_applet.call(request)
        end
      end
    end

    private

    # "/path/to/foo_controller.rb" => FooController
    def controller_from_path(path)
      if path.split('/')[-2] != 'controllers'
        (path.split('/')[-2].camelize + '::' + File.basename(path, '.rb').camelize).constantize
      else
        File.basename(path, '.rb').camelize.constantize
      end
    end
  end
end
