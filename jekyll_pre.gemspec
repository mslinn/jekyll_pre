# frozen_string_literal: true

require_relative "lib/jekyll_pre/version"

# rubocop:disable Metrics/BlockLength
Gem::Specification.new do |spec|
  github = "https://github.com/mslinn/jekyll_pre"

  spec.authors = ["Mike Slinn"]
  spec.bindir = "exe"
  spec.description = <<~END_OF_DESC
    Jekyll tags pre and noselect, for HTML <pre/> tag, prompts and unselectable text. Can number lines.
  END_OF_DESC
  spec.email = ["mslinn@mslinn.com"]
  spec.files = Dir[".rubocop.yml", "LICENSE.*", "Rakefile", "{lib,spec}/**/*", "*.gemspec", "*.md"]
  spec.homepage = "https://www.mslinn.com/blog/2020/10/03/jekyll-plugins.html#pre"
  spec.license = "MIT"
  spec.metadata = {
    "allowed_push_host" => "https://rubygems.org",
    "bug_tracker_uri"   => "#{github}/issues",
    "changelog_uri"     => "#{github}/CHANGELOG.md",
    "homepage_uri"      => spec.homepage,
    "source_code_uri"   => github,
  }
  spec.name = "jekyll_pre"
  spec.post_install_message = <<~END_MESSAGE

    Thanks for installing #{spec.name}!

  END_MESSAGE
  spec.require_paths = ["lib"]
  spec.required_ruby_version = ">= 2.6.0"
  spec.summary = "Jekyll tags pre and noselect, for HTML <pre/> tag, prompts and unselectable text. Can number lines."
  spec.test_files = spec.files.grep(%r!^(test|spec|features)/!)
  spec.version = JekyllPre::VERSION

  spec.add_dependency "jekyll", ">= 3.5.0"
  spec.add_dependency "jekyll_plugin_logger"
  spec.add_dependency "key-value-parser"
  spec.add_dependency "shellwords"

  spec.add_development_dependency "debase"
  # spec.add_development_dependency "rubocop-jekyll"
  # spec.add_development_dependency "rubocop-rake"
  # spec.add_development_dependency "rubocop-rspec"
  spec.add_development_dependency "ruby-debug-ide"
end
# rubocop:enable Metrics/BlockLength
