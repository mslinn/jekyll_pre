require 'jekyll_plugin_support'
require_relative 'jekyll_pre/version'

module JekyllPreModule
  # """\\{% noselect %} or \\{% noselect this all gets copied.
  # Also, space before the closing percent is signficant %}"""
  class NoSelectTag < ::JekyllSupport::JekyllTagNoArgParsing
    include JekyllPreVersion

    def render_impl
      text = @argument_string
      text = if text.nil? || text.empty?
               '$ '
             else
               "#{text} "
             end
      "<span class='unselectable'>#{text}</span>"
    end

    ::JekyllSupport::JekyllPluginHelper.register(self, 'noselect')
  end
end
