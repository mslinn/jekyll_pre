require 'jekyll_plugin_support'

module ExecTag
  class ExecTag < JekyllSupport::JekyllTag
    include JekyllPreVersion

    def render_impl
      parse_args

      command = @argument_string
      response = `#{command}`
      if @die_if_nonzero && !$CHILD_STATUS.success?
        msg = "Error: executing '#{command}' on line #{@line_number} (after front matter) of #{@page['path']} returned error code #{$CHILD_STATUS.exitstatus}"
        raise PreError, msg.red, []
      end

      response = compress response

      <<~END_OUTPUT
        #{Rack::Utils.escape_html(command)}
        <span class='unselectable'>#{response}</span>
      END_OUTPUT
    rescue PreError => e
      raise PreError, e.message, []
    rescue StandardError => e
      msg = remove_html_tags(e.message) + " from executing '#{command}' on line #{@line_number} (after front matter) of #{@page['path']}"
      raise PreError, msg.red, [] if die_if_error
    end

    private

    def compress(response)
      result = response.chomp
      result = result.strip unless @no_strip
      result = result.gsub('\n\n', '<br>\n')
      result = Rack::Utils.escape_html(result) unless @no_escape
      result
    end

    def parse_args
      @no_escape      = @helper.parameter_specified? 'no_escape'
      @no_strip       = @helper.parameter_specified? 'no_strip'
      @die_if_nonzero = @helper.parameter_specified?('die_if_nonzero') | true # Implies die_if_error
      @die_if_error   = @helper.parameter_specified?('die_if_error') | @die_if_nonzero
    end

    JekyllPluginHelper.register(self, 'exec')
  end

  private

  def die(msg)
    msg_no_html = remove_html_tags(msg)
    @logger.error("#{@page['path']} - #{msg_no_html}")
    raise PreError, "#{@page['path']} - #{msg_no_html.red}", []
  end

  def remove_html_tags(string)
    string.gsub(/<[^>]*>/, '')
  end
end
