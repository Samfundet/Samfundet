# frozen_string_literal: true

# Expose generated CSS to the application.css Sprockets manifest.
Rails.application.config.assets.paths.unshift(Rails.root.join('app/assets/builds'))
Rails.application.config.dartsass.builds = { 'application.scss' => 'samfundet.css' }

# Keep legacy imports working while the stylesheets are migrated to Sass modules.
Rails.application.config.dartsass.build_options += ['--no-error-css', '--quiet-deps', '--silence-deprecation=import,global-builtin,color-functions,slash-div,if-function']
