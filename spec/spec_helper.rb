require 'jekyll'
require 'fileutils'
require 'key_value_parser'
require 'jekyll_plugin_support'
require 'rack/utils'
require 'shellwords'

require_relative '../lib/jekyll_pre'

Jekyll.logger.log_level = :info

RSpec.configure do |config|
  config.filter_run_when_matching focus: true
  # config.order = 'random'

  # See https://relishapp.com/rspec/rspec-core/docs/command-line/only-failures
  config.example_status_persistence_file_path = 'spec/status_persistence.txt'
end
