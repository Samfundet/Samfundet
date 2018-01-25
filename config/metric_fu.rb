# -*- encoding : utf-8 -*-
# frozen_string_literal: true
MetricFu::Configuration.run do |config|
  # Define which metrics you want to use.
  config.metrics  = [:churn, :saikuro, :stats, :flog, :flay, :reek, :roodi]
  config.graphs   = [:flog, :flay, :reek, :roodi]
  config.flay     = { dirs_to_flay: %w(app lib),
                      minimum_score: 100 }
  config.flog     = { dirs_to_flog: %w(app lib)  }
  config.reek     = { dirs_to_reek: %w(app lib)  }
  config.roodi    = { dirs_to_roodi: %w(app lib) }
  config.saikuro  = { output_directory: 'scratch_directory/saikuro',
                      input_directory: %w(app lib),
                      cyclo: '',
                      filter_cyclo: '0',
                      warn_cyclo: '5',
                      error_cyclo: '7',
                      formater: 'text' } # This needs to be set to "text".
  config.churn    = { start_date: '1 year ago', minimum_churn_count: 10 }
  config.graph_engine = :bluff
end
