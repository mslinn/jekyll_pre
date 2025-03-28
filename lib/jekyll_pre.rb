module JekyllPluginPreName
  PLUGIN_NAME = 'jekyll_pre'.freeze
end

require_relative 'exec_tag'
require_relative 'noselect_tag'
require_relative 'pre_tag_block'

PreError = Class.new(Liquid::Error)

class String
  # Works like <<~ from Ruby 2.3.0
  def dedent
    # Find the margin whitespace on the first line
    margin = self[/\A\s*/]
    # Remove margin-sized whitespace from each line
    gsub(/^\s{#{margin.size}}/, '')
  end
end

PluginMetaLogger.instance.info { "Loaded #{JekyllPluginPreName::PLUGIN_NAME} v#{JekyllPreVersion::VERSION} plugin." }
