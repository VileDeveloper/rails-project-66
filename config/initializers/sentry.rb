# frozen_string_literal: true

Sentry.init do |config|
  config.enabled_environments = %w[production]

  config.dsn = 'https://a8005a64bc90942859656b3c9ab2ccf9@o4506610010816512.ingest.us.sentry.io/4507477450293248'
  config.breadcrumbs_logger = %i[active_support_logger http_logger]

  # Set traces_sample_rate to 1.0 to capture 100%
  # of transactions for performance monitoring.
  # We recommend adjusting this value in production.
  config.traces_sample_rate = 1.0
  # or
  config.traces_sampler = lambda do |_context|
    true
  end
  # Set profiles_sample_rate to profile 100%
  # of sampled transactions.
  # We recommend adjusting this value in production.
  config.profiles_sample_rate = 1.0
end
