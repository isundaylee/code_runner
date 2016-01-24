require 'open3'

class InterpretedCodeRunner
  class EnvironmentError < RuntimeError; end

  SILENCE_OUTPUT = ' 1>/dev/null 2>/dev/null'

  def initialize(interpreter, extension, options = {})
    @use_env = options.has_key?(:use_env) ? options[:use_env] : true

    @extension = extension
    @interpreter = @use_env ? "/usr/bin/env #{interpreter}" : interpreter

    # Sanity check for interpreter
    success = system("echo '' | " + @interpreter + SILENCE_OUTPUT)
    raise EnvironmentError, 'Interpreter exits with non-zero return code. ' unless success
  end

  def accepts_filename?(filename)
    File.extname(filename)[1..-1] == @extension
  end

  def run(filename)
    command = "#{@interpreter} #{filename}"

    stdout, stderr, status = Open3.capture3(command)

    {
      stdout: stdout,
      stderr: stderr,
      status: status.exitstatus
    }
  end
end