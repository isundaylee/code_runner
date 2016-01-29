require 'code_runners/base_code_runner'

require 'open3'
require 'zip'
require 'tmpdir'

class MakeCodeRunner < BaseCodeRunner
  class EnvironmentError < RuntimeError; end

  SILENCE_OUTPUT = ' 1>/dev/null 2>/dev/null'

  def initialize(options = {})
    @use_env = options.has_key?(:use_env) ? options[:use_env] : true

    @make = @use_env ? "/usr/bin/env make" : "make"

    # Sanity check for make
    success = system(@make + " -v" + SILENCE_OUTPUT)
    raise EnvironmentError, "`make' exits with non-zero return code. " unless success
  end

  def accepts_filename?(filename)
    false
  end

  def accepts_zipfile?(path)
    Zip::File.open(path) do |zip|
      zip.glob('makefile').any? || zip.glob('Makefile').any? 
    end
  end

  def run(path)
    filename = File.basename(path)

    Dir.mktmpdir do |dir|
      FileUtils.cp(path, File.join(dir, filename))
      system("cd \"#{dir}\" && unzip \"#{filename}\"" + SILENCE_OUTPUT)

      stdout, stderr, status = Open3.capture3("cd \"#{dir}\" && make run")

      {
        stdout: stdout,
        stderr: stderr,
        status: status.exitstatus
      }
    end
  end
end