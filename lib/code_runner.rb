require 'code_runners/interpreted_code_runner'

class CodeRunner
  AVAILABLE_RUNNERS = [
    InterpretedCodeRunner.new('ruby', 'rb'),
    InterpretedCodeRunner.new('python', 'py'),
  ]

  class NoCompatibleRunner < RuntimeError; end

  def run(filename)
    puts filename
    runner = AVAILABLE_RUNNERS.detect { |r| r.accepts_filename?(filename) }

    raise NoCompatibleRunner, 'File type not supported yet. ' if runner.nil?

    runner.run(filename)
  end
end