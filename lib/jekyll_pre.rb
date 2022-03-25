# frozen_string_literal: true

require "liquid"
require "jekyll_plugin_logger"
require_relative "jekyll_pre/version"

module JekyllPluginPreName
  PLUGIN_NAME = "jekyll_pre"
end

# """
#   \\{% pre %}
#   Content here
#   \\{% endpre %}
#
#   \\{% pre copyButton %}
#   Content here
#   \\{% endpre %}"""
#
#   \\{% pre shell %}
#   Content here
#   \\{% endpre %}
#
#   \\{% pre copyButton shell %}
#   Content here
#   \\{% endpre %}
#
#   \\{% pre copyButton label %}
#   Content here
#   \\{% endpre %}"""
class PreTagBlock < Liquid::Block
  @@prefix = "<button class='copyBtn' data-clipboard-target="
  @@suffix = " title='Copy to clipboard'><img src='/assets/images/clippy.svg' " \
              "alt='Copy to clipboard' style='width: 13px'></button>"

  def self.make_copy_button(pre_id)
    "#{@@prefix}'##{pre_id}'#{@@suffix}"
  end

  def self.make_pre(make_copy_button, label, content)
    label = if label.to_s.empty?
              ""
            elsif label.to_s.downcase.strip == "shell"
              "<div class='codeLabel unselectable' data-lt-active='false'>Shell</div>"
            else
              "<div class='codeLabel unselectable' data-lt-active='false'>#{label}</div>"
            end
    pre_id = "id#{SecureRandom.hex(6)}"
    copy_button = make_copy_button ? PreTagBlock.make_copy_button(pre_id) : ""
    "#{label}<pre data-lt-active='false' class='maxOneScreenHigh copyContainer' id='#{pre_id}'>#{copy_button}#{content.strip}</pre>"
  end

  # @param tag_name [String] is the name of the tag, which we already know.
  # @param text [Hash, String, Liquid::Tag::Parser] the arguments from the web page.
  # @param tokens [Liquid::ParseContext] tokenized command line
  # @return [void]
  def initialize(tag_name, text, tokens)
    super(tag_name, text, tokens)
    text = "" if text.nil?
    text.strip!
    @make_copy_button = text.include? "copyButton"
    remaining_text = text.sub("copyButton", "").strip
    @logger = PluginMetaLogger.instance.new_logger(self)
    @logger.debug { "@make_copy_button = '#{@make_copy_button}'; text = '#{text}'; remaining_text = '#{remaining_text}'" }
    @label = remaining_text
  end

  # Method prescribed by the Jekyll plugin lifecycle.
  # @return [String]
  def render(context)
    content = super
    @logger.debug { "@make_copy_button = '#{@make_copy_button}'; @label = '#{@label}'" }
    PreTagBlock.make_pre(@make_copy_button, @label, content)
  end
end

# """\\{% noselect %} or \\{% noselect this all gets copied.
# Also, space before the closing percent is signficant %}"""
class UnselectableTag < Liquid::Tag
  def initialize(tag_name, text, tokens)
    super(tag_name, text, tokens)
    @content = text
    @logger = PluginMetaLogger.instance.new_logger(self)
    @logger.debug { "UnselectableTag: content1= '#{@content}'" }
    @content = "$ " if @content.nil? || @content.empty?
    @logger.debug { "UnselectableTag: content2= '#{@content}'" }
  end

  def render(_)
    "<span class='unselectable'>#{@content}</span>"
  end
end

PluginMetaLogger.instance.info { "Loaded #{JekyllPluginPreName::PLUGIN_NAME} v#{JekyllPre::VERSION} plugin." }
Liquid::Template.register_tag("pre", PreTagBlock)
Liquid::Template.register_tag("noselect", UnselectableTag)
