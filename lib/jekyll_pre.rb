# frozen_string_literal: true

require 'liquid'
require 'jekyll_plugin_logger'
require 'key_value_parser'
require 'shellwords'
require_relative 'jekyll_pre/version'
require_relative 'jekyll_tag_helper'

module JekyllPluginPreName
  PLUGIN_NAME = 'jekyll_pre'
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

  def self.highlight(content, pattern)
    content.gsub(Regexp.new(pattern), "<span class='bg_yellow'>\\0</span>")
  end

  def self.make_copy_button(pre_id)
    "#{@@prefix}'##{pre_id}'#{@@suffix}"
  end

  def self.make_pre(make_copy_button, number_lines, label, dark, highlight_pattern, css_class, style, clear, content) # rubocop:disable Metrics/ParameterLists, Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity, Metrics/MethodLength
    pre_clear = label_clear = ''
    if clear
      if label.to_s.empty?
        pre_clear = ' clear'
      else
        label_clear = ' clear'
      end
    end
    css_class = css_class ? " #{css_class}" : ''
    style = style ? " style='#{style}'" : ''
    dark_label = ' darkLabel' if dark
    label = if label.to_s.empty?
              ''
            elsif label.to_s.downcase.strip == 'shell'
              "<div class='codeLabel unselectable#{dark_label}#{label_clear}' data-lt-active='false'>Shell</div>"
            else
              "<div class='codeLabel unselectable#{dark_label}#{label_clear}' data-lt-active='false'>#{label}</div>"
            end
    pre_id = "id#{SecureRandom.hex(6)}"
    copy_button = make_copy_button ? PreTagBlock.make_copy_button(pre_id) : ''
    content = PreTagBlock.highlight(content, highlight_pattern) if highlight_pattern
    content = PreTagBlock.number_content(content) if number_lines
    "#{label}<pre data-lt-active='false' class='maxOneScreenHigh copyContainer#{dark}#{pre_clear}#{css_class}'#{style} id='#{pre_id}'>#{copy_button}#{content.strip}</pre>"
  end

  def self.number_content(content) # rubocop:disable Metrics/MethodLength
    lines = content.split("\n")
    digits = lines.length.to_s.length
    i = 0
    numbered_content = lines.map do |line|
      i += 1
      number = i.to_s.rjust(digits, ' ')
      "<span class='unselectable numbered_line'> #{number}: </span>#{line}"
    end
    result = numbered_content.join("\n")
    result += "\n" unless result.end_with?("\n")
    result
  end

  # @param _tag_name [String] is the name of the tag, which we already know.
  # @param markup [String] the arguments from the web page.
  # @param _tokens [Liquid::ParseContext] tokenized command line
  #        By default it has two keys: :locale and :line_numbers, the first is a Liquid::I18n object, and the second,
  #        a boolean parameter that determines if error messages should display the line number the error occurred.
  #        This argument is used mostly to display localized error messages on Liquid built-in Tags and Filters.
  #        See https://github.com/Shopify/liquid/wiki/Liquid-for-Programmers#create-your-own-tags
  # @return [void]
  def initialize(_tag_name, markup, _tokens)
    super
    markup = '' if markup.nil?
    markup.strip!

    @logger = PluginMetaLogger.instance.new_logger(self, PluginMetaLogger.instance.config)
    @helper = JekyllTagHelper.new(tag_name, markup, @logger)
  end

  # Method prescribed by the Jekyll plugin lifecycle.
  # @param liquid_context [Liquid::Context]
  # @return [String]
  def render(liquid_context) # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
    content = super
    @helper.liquid_context = liquid_context

    @clear = @helper.parameter_specified?('clear')
    @class = @helper.parameter_specified?('class')
    @highlight = @helper.parameter_specified? 'highlight'
    @make_copy_button = @helper.parameter_specified? 'copyButton'
    @number_lines = @helper.parameter_specified? 'number'
    @dark = ' dark' if @helper.parameter_specified? 'dark'
    @label = @helper.parameter_specified? 'label'
    @style = @helper.parameter_specified?('style')

    # If a label was specified, use it, otherwise concatenate any dangling parameters and use that as the label
    @label ||= @helper.params.join(' ')

    @logger.debug { "@make_copy_button = '#{@make_copy_button}'; @label = '#{@label}'" }
    PreTagBlock.make_pre(@make_copy_button, @number_lines, @label, @dark, @highlight, @class, @style, @clear, content)
  end
end

# """\\{% noselect %} or \\{% noselect this all gets copied.
# Also, space before the closing percent is signficant %}"""
class UnselectableTag < Liquid::Tag
  # @param _tag_name [String] is the name of the tag, which we already know.
  # @param markup [String] the arguments from the web page.
  # @param _tokens [Liquid::ParseContext] tokenized command line
  # @return [void]
  def initialize(_tag_name, markup, _tokens)
    super
    @logger = PluginMetaLogger.instance.new_logger(self)

    @markup = markup
    @markup = '$ ' if @markup.nil? || @markup.empty?
    @logger.debug { "UnselectableTag: markup= '#{@markup}'" }
  end

  def render(_)
    "<span class='unselectable'>#{@markup}</span>"
  end
end

PluginMetaLogger.instance.info { "Loaded #{JekyllPluginPreName::PLUGIN_NAME} v#{JekyllPreVersion::VERSION} plugin." }
Liquid::Template.register_tag('pre', PreTagBlock)
Liquid::Template.register_tag('noselect', UnselectableTag)
