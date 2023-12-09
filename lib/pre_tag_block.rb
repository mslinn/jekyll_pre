require 'jekyll_plugin_support'
require 'securerandom'
require_relative 'jekyll_pre/version'

module JekyllPreModule
  class PreTagBlock < JekyllSupport::JekyllBlock
    include JekyllPreVersion

    @@prefix = "<button class='copyBtn' data-clipboard-target="
    @@suffix = " title='Copy to clipboard'><img src='/assets/images/clippy.svg' " \
               "alt='Copy to clipboard' style='width: 13px'></button>"

    def self.highlight(content, pattern)
      content.gsub(Regexp.new(pattern), "<span class='bg_yellow'>\\0</span>")
    end

    def self.make_copy_button(pre_id)
      "#{@@prefix}'##{pre_id}'#{@@suffix}"
    end

    def self.number_content(content)
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

    # remove leading blank lines and trailing whitespace
    def self.remove_surrounding(text)
      text.gsub(/\A(\s?\n)*/, '').rstrip
    end

    def option(name)
      value = @helper.parameter_specified? name
      return value unless value.nil?

      @pre_config[name] if @pre_config
    end

    def render_impl(text)
      text = PreTagBlock.remove_surrounding text

      @helper.gem_file __FILE__ # Enables plugin attribution

      @pre_config = @config['pre']

      @class            = option 'class'
      @clear            = option 'clear'
      @dark             = ' dark' if option 'dark'
      @dedent           = option 'dedent'
      @highlight        = option 'highlight'
      @make_copy_button = option 'copyButton'
      @number_lines     = option 'number'
      @style            = option 'style'
      @wrapper_class    = option 'wrapper_class'
      @wrapper_style    = option 'wrapper_style'

      @class = @class ? " #{@class}" : ''
      @style = @style ? " style='#{@style}'" : ''
      @wrapper_class = @wrapper_class ? " #{@wrapper_class}" : ''
      @wrapper_style = @wrapper_style ? " style='#{@wrapper_style}'" : ''

      # If a label was specified, use it, otherwise concatenate any dangling parameters and use that as the label
      label_implicit = @helper.argv.join(' ')
      label_option   = option 'label'
      @label = label_option && label_option.to_s != 'true' ? label_option : label_implicit

      @logger.debug { "@make_copy_button = '#{@make_copy_button}'; @label = '#{@label}'" }

      text = text.dedent if @dedent
      make_pre(text)
    end

    private

    def make_pre(content)
      pre_clear = label_clear = ''
      if @clear
        if @label.to_s.empty?
          pre_clear = ' clear'
        else
          label_clear = ' clear'
        end
      end
      dark_label = ' darkLabel' if @dark
      @label = if @label.to_s.empty?
                 ''
               elsif @label.to_s.casecmp('shell').zero?
                 "<div class='codeLabel unselectable#{dark_label}#{label_clear}' data-lt-active='false'>Shell</div>"
               else
                 "<div class='codeLabel unselectable#{dark_label}#{label_clear}' data-lt-active='false'>#{@label}</div>"
               end
      pre_id = "id#{SecureRandom.hex(6)}"
      copy_button = @make_copy_button ? PreTagBlock.make_copy_button(pre_id) : ''
      content = PreTagBlock.highlight(content, @highlight) if @highlight
      content = PreTagBlock.number_content(content) if @number_lines

      classes = "maxOneScreenHigh copyContainer#{@dark}#{pre_clear}#{@class}"
      pre_content = "#{copy_button}#{content}"
      attribution = @helper.attribute if @helper.attribution
      <<~END_OUTPUT
        <div class="jekyll_pre#{@wrapper_class}" #{@wrapper_style}>
        #{@label}
        <pre data-lt-active='false' class='#{classes}'#{@style} id='#{pre_id}'>#{pre_content}</pre>
        #{attribution}
        </div>
      END_OUTPUT
    end

    JekyllPluginHelper.register(self, 'pre')
  end
end
