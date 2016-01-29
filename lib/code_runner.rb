require 'code_runners/interpreted_code_runner'
require 'code_runners/make_code_runner'

class CodeRunner
  AVAILABLE_RUNNERS = [
    InterpretedCodeRunner.new('ruby', 'rb'),
    InterpretedCodeRunner.new('python', 'py'),
    MakeCodeRunner.new
  ]

  class NoCompatibleRunner < RuntimeError; end

  def run(path)
    runner = AVAILABLE_RUNNERS.detect do |r| 
      r.accepts_filename?(path) || 
      (is_zip_file?(path) && r.accepts_zipfile?(path))
    end

    raise NoCompatibleRunner, 'File type not supported yet. ' if runner.nil?

    runner.run(path)
  end

  private
    def is_zip_file?(filename)
      File.extname(filename) == '.zip'
    end
end
