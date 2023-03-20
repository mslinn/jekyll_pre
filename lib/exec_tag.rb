require 'jekyll_plugin_support'
require_relative 'jekyll_pre/version'

module ExecTag
  class ExecTag < JekyllSupport::JekyllTag
    include JekyllPreVersion

    def self.remove_html_tags(string)
      string.gsub(/<[^>]*>/, '')
    end

    def render_impl
      parse_args
      @original_command = @helper.remaining_markup_original
      command = JekyllPluginHelper.expand_env(@original_command)
      raise PreError, "Command is empty on on line #{@line_number} (after front matter) of #{@page['path']}", [] if command.strip.empty?

      response = run_command(command)
      response = if @child_status.success?
                   compress(response)
                 else
                   handle_error(command)
                 end

      <<~END_OUTPUT
        #{Rack::Utils.escape_html(@original_command)}
        <span class='unselectable'>#{response}</span>
      END_OUTPUT
    rescue PreError => e
      raise PreError, e.message, []
    rescue StandardError => e
      msg = self.class.remove_html_tags(e.message) + " from executing '#{@original_command}' on line #{@line_number} (after front matter) of #{@page['path']}"
      raise PreError, msg.red, [] if @die_if_error
    end

    private

    def compress(response)
      result = response.chomp
      result = result.strip unless @no_strip
      result = result.gsub('\n\n', '<br>\n')
      result = Rack::Utils.escape_html(result) unless @no_escape
      result
    end

    def die(msg)
      msg_no_html = self.class.remove_html_tags(msg)
      @logger.error("#{@page['path']} - #{msg_no_html}")
      raise PreError, "#{@page['path']} - #{msg_no_html.red}", []
    end

    def handle_error(command)
      msg0 = "Error: executing '#{command}'"
      msg0 += " (expanded from #{@original_command})" if command != @original_command
      msg0 += " in directory '#{@cd}'" if @cd
      msg = <<~END_MSG
        #{msg0} on line #{@line_number} (after front matter) of #{@page['path']} returned error code #{@child_status.exitstatus}
      END_MSG
      raise PreError, msg.red, [] if @die_if_nonzero

      @logger.error { msg }
      "<span class='error'>Error code #{@child_status.exitstatus}</span>"
    end

    def parse_args
      @cd = @helper.parameter_specified? 'cd'
      @cd = JekyllPluginHelper.expand_env(@cd) if @cd

      @no_escape      = @helper.parameter_specified? 'no_escape'
      @no_strip       = @helper.parameter_specified? 'no_strip'
      @die_if_nonzero = @helper.parameter_specified?('die_if_nonzero') # Implies die_if_error
      @die_if_error   = @helper.parameter_specified?('die_if_error') | @die_if_nonzero
    end

    # References @cd
    # Defines @child_status
    # @return result of running command
    # @param command [String] Shell command to execute
    def run_command(command)
      result = if @cd
                 Dir.chdir(@cd) do
                   `#{command}`
                 end
               else
                 `#{command}`
               end
      @child_status = $CHILD_STATUS
      result
    rescue StandardError => e
      msg = self.class.remove_html_tags(e.message) + " from executing '#{@original_command}' on line #{@line_number} (after front matter) of #{@page['path']}"
      raise PreError, msg.red, [] if @die_if_error
    ensure
      @child_status = $CHILD_STATUS
      result
    end

    JekyllPluginHelper.register(self, 'exec')
  end
end
