require 'jekyll_plugin_support'
require_relative 'jekyll_pre/version'

module PreTagBlock
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

    def render_impl(text)
      text.strip!
      @helper.gem_file __FILE__ # Enables plugin attribution

      @class = @helper.parameter_specified? 'class'
      @clear = @helper.parameter_specified? 'clear'
      @dark = ' dark' if @helper.parameter_specified? 'dark'
      @highlight = @helper.parameter_specified? 'highlight'
      @label = @helper.parameter_specified? 'label'
      @make_copy_button = @helper.parameter_specified? 'copyButton'
      @number_lines = @helper.parameter_specified? 'number'
      @style = @helper.parameter_specified? 'style'
      @wrapper_class = @helper.parameter_specified? 'wrapper_class'
      @wrapper_style = @helper.parameter_specified? 'wrapper_style'

      # If a label was specified, use it, otherwise concatenate any dangling parameters and use that as the label
      @label ||= @helper.argv.join(' ')

      @logger.debug { "@make_copy_button = '#{@make_copy_button}'; @label = '#{@label}'" }
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
      @class = @class ? " #{@class}" : ''
      @style = @style ? " style='#{@style}'" : ''
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
        <div class="#{@wrapper_class}" style="#{@wrapper_style}">
        #{@label}
        <pre data-lt-active='false' class='#{classes}'#{@style} id='#{pre_id}'>#{pre_content}</pre>
        #{attribution}
        </div>
      END_OUTPUT
    end

    JekyllPluginHelper.register(self, 'pre')
  end
end