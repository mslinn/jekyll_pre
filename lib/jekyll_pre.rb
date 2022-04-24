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

  def self.highlight(content, pattern)
    content.gsub(Regexp::new(pattern), "<span class='bg_yellow'>\\0</span>")
  end

  def self.make_copy_button(pre_id)
    "#{@@prefix}'##{pre_id}'#{@@suffix}"
  end

  def self.make_pre(make_copy_button, number_lines, label, dark, highlight_pattern, content) # rubocop:disable Metrics/ParameterLists
    dark_label = " darkLabel" if dark
    label = if label.to_s.empty?
              ""
            elsif label.to_s.downcase.strip == "shell"
              "<div class='codeLabel unselectable#{dark_label}' data-lt-active='false'>Shell</div>"
            else
              "<div class='codeLabel unselectable#{dark_label}' data-lt-active='false'>#{label}</div>"
            end
    pre_id = "id#{SecureRandom.hex(6)}"
    copy_button = make_copy_button ? PreTagBlock.make_copy_button(pre_id) : ""
    content = PreTagBlock.highlight(content, highlight_pattern)
    content = PreTagBlock.number_content(content) if number_lines
    "#{label}<pre data-lt-active='false' class='maxOneScreenHigh copyContainer#{dark}' id='#{pre_id}'>#{copy_button}#{content.strip}</pre>"
  end

  def self.number_content(content)
    lines = content.split("\n")
    digits = lines.length.to_s.length
    i = 0
    numbered_content = lines.map do |line|
      i += 1
      number = i.to_s.rjust(digits, " ")
      "<span class='unselectable numbered_line'> #{number}: </span>#{line}"
    end
    result = numbered_content.join("\n")
    result += "\n" unless result.end_with?("\n")
    result
  end

  # @param _tag_name [String] is the name of the tag, which we already know.
  # @param argument_string [String] the arguments from the web page.
  # @param _tokens [Liquid::ParseContext] tokenized command line
  # @return [void]
  def initialize(_tag_name, argument_string, _tokens)
    super
    argument_string = "" if argument_string.nil?
    argument_string.strip!

    @logger = PluginMetaLogger.instance.new_logger(self, PluginMetaLogger.instance.config)

    @highlight = argument_string.include? "highlight"
    remaining_text = argument_string.sub("highlight", "").strip

    @make_copy_button = remaining_text.include? "copyButton"
    remaining_text = argument_string.sub("copyButton", "").strip

    @number_lines = remaining_text.include? "number"
    remaining_text = remaining_text.sub("number", "").strip

    @dark = " dark" if remaining_text.include? "dark"
    remaining_text = remaining_text.sub("dark", "").strip

    @label = remaining_text

    @logger.debug { "@make_copy_button = '#{@make_copy_button}'; argument_string = '#{argument_string}'; remaining_text = '#{remaining_text}'" }
  end

  # Method prescribed by the Jekyll plugin lifecycle.
  # @return [String]
  def render(context)
    content = super
    @logger.debug { "@make_copy_button = '#{@make_copy_button}'; @label = '#{@label}'" }
    PreTagBlock.make_pre(@make_copy_button, @number_lines, @label, @dark, @highlight, content)
  end
end

# """\\{% noselect %} or \\{% noselect this all gets copied.
# Also, space before the closing percent is signficant %}"""
class UnselectableTag < Liquid::Tag
  # @param _tag_name [String] is the name of the tag, which we already know.
  # @param argument_string [String] the arguments from the web page.
  # @param _tokens [Liquid::ParseContext] tokenized command line
  # @return [void]
  def initialize(_tag_name, argument_string, _tokens)
    super
    @logger = PluginMetaLogger.instance.new_logger(self)

    @argument_string = argument_string
    @argument_string = "$ " if @argument_string.nil? || @argument_string.empty?
    @logger.debug { "UnselectableTag: argument_string= '#{@argument_string}'" }
  end

  def render(_)
    "<span class='unselectable'>#{@argument_string}</span>"
  end
end

PluginMetaLogger.instance.info { "Loaded #{JekyllPluginPreName::PLUGIN_NAME} v#{JekyllPreVersion::VERSION} plugin." }
Liquid::Template.register_tag("pre", PreTagBlock)
Liquid::Template.register_tag("noselect", UnselectableTag)
