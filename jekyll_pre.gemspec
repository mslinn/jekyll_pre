require 'jekyll'
require_relative 'lib/jekyll_pre/version'

Gem::Specification.new do |spec|
  github = 'https://github.com/mslinn/jekyll_pre'

  spec.authors = ['Mike Slinn']
  spec.bindir = 'exe'
  spec.description = <<~END_OF_DESC
    Jekyll tags pre and noselect, for HTML <pre/> tag, prompts and unselectable text. Can number lines.
  END_OF_DESC
  spec.email = ['mslinn@mslinn.com']
  spec.files = Dir['.rubocop.yml', 'LICENSE.*', 'Rakefile', '{lib,spec}/**/*', '*.gemspec', '*.md']
  spec.homepage = 'https://www.mslinn.com/jekyll_plugins/jekyll_pre.html'
  spec.license = 'MIT'
  spec.metadata = {
    'allowed_push_host' => 'https://rubygems.org',
    'bug_tracker_uri'   => "#{github}/issues",
    'changelog_uri'     => "#{github}/CHANGELOG.md",
    'homepage_uri'      => spec.homepage,
    'source_code_uri'   => github,
  }
  spec.name = 'jekyll_pre'
  spec.post_install_message = <<~END_MESSAGE

    Thanks for installing #{spec.name}!

  END_MESSAGE
  spec.require_paths = ['lib']
  spec.required_ruby_version = '>= 2.6.0'
  spec.summary = 'Jekyll tags pre and noselect, for HTML <pre/> tag, prompts and unselectable text. Can number lines.'
  spec.test_files = spec.files.grep(%r{^(test|spec|features)/})
  spec.version = JekyllPreVersion::VERSION

  spec.add_dependency 'jekyll', '>= 3.5.0'
  spec.add_dependency 'jekyll_plugin_support', '>= 0.7.0'
  spec.add_dependency 'rack'
end
