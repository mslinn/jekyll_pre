require 'jekyll_plugin_support'
require 'rack/utils'
require_relative 'jekyll_pre/version'

module JekyllPreModule
  def self.compress(response, no_strip)
    result = response.chomp
    result = result.strip unless no_strip
    result = result.gsub('\n\n', '<br>\n')
    result = Rack::Utils.escape_html(result) unless @no_escape
    result
  end

  class ExecTag < JekyllSupport::JekyllTag
    include JekyllPreVersion

    def self.remove_html_tags(string)
      string.gsub(/<[^>]*>/, '')
    end

    def render_impl
      parse_args
      @original_command = @helper.remaining_markup_original
      command = JekyllPluginHelper.expand_env @original_command
      if command.strip.empty?
        msg = "Command is empty on on line #{@line_number} (after front matter) of #{@page['path']}"
        unless @die_if_error
          @logger.warn { msg }
          return ''
        end
        raise PreError, msg, []
      end

      response = run_command(command)
      response = if @child_status.success?
                   JekyllPreModule.compress(response, @no_strip)
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
      msg = self.class.remove_html_tags(e.message) +
            " from executing '#{@original_command}' on line #{@line_number} (after front matter) of #{@page['path']}"
      raise PreError, msg.red, [] if @die_if_error
    end

    private

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
      @no_stderr      = @helper.parameter_specified? 'no_stderr'
      @die_if_nonzero = @helper.parameter_specified?('die_if_nonzero') # Implies die_if_error
      @die_if_error   = @helper.parameter_specified?('die_if_error') | @die_if_nonzero
    end

    # References @cd
    # Defines @child_status
    # Ignores stderr output
    # @return result of running command
    # @param command [String] Shell command to execute
    def run_command(command)
      stdout_str = ''
      stderr_str = ''
      if @cd
        Dir.chdir(@cd) do
          @logger.debug { "Executing '#{command}' from '#{@cd}'" }
          stdout_str, stderr_str, @child_status = Open3.capture3 command
        end
      else
        @logger.debug { "Executing '#{command}'" }
        stdout_str, stderr_str, @child_status = Open3.capture3 command
      end
      unless @no_stderr
        stderr_str.strip!
        unless stderr_str.empty?
          @logger.info do
            "'#{command}' STDERR=#{stderr_str}\nThe exec subcommand's 'no_stderr' option suppresses this message."
          end
        end
      end
      stdout_str
    rescue StandardError => e
      msg = self.class.remove_html_tags(e.message) +
            " from executing '#{@original_command}' on line #{@line_number} (after front matter) of #{@page['path']}"
      raise PreError, msg.red, [] if @die_if_error
    ensure
      @child_status = $CHILD_STATUS
      stdout_str
    end

    JekyllPluginHelper.register(self, 'exec')
  end
end
