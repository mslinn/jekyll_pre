require 'jekyll_plugin_support'

module NoSelectTag
  # """\\{% noselect %} or \\{% noselect this all gets copied.
  # Also, space before the closing percent is signficant %}"""
  class NoSelectTag < JekyllSupport::JekyllTagNoArgParsing
    include JekyllPreVersion

    def render_impl
      text = @argument_string
      text = '$ ' if text.nil? || text.empty?
      "<span class='unselectable'>#{text}</span>"
    end

    JekyllPluginHelper.register(self, 'noselect')
  end
end
