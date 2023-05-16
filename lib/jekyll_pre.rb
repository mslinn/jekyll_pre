module JekyllPluginPreName
  PLUGIN_NAME = 'jekyll_pre'.freeze
end

require_relative './exec_tag'
require_relative './noselect_tag'
require_relative './pre_tag_block'

PreError = Class.new(Liquid::Error)

module JekyllPreModule
  include NoSelectTag
  include PreTagBlock
  include ExecTagModule
end

PluginMetaLogger.instance.info { "Loaded #{JekyllPluginPreName::PLUGIN_NAME} v#{JekyllPreVersion::VERSION} plugin." }
