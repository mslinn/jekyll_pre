module JekyllPluginPreName
  PLUGIN_NAME = 'jekyll_pre'.freeze
end

require_relative './jekyll_pre_tag'
require_relative './jekyll_noselect_tag'

module JekyllPreModule
  include PreTagBlock
  include NoSelectTag
end

PluginMetaLogger.instance.info { "Loaded #{JekyllPluginPreName::PLUGIN_NAME} v#{JekyllPreVersion::VERSION} plugin." }
