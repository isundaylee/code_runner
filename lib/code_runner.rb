require 'code_runners/interpreted_code_runner'

class CodeRunner
  AVAILABLE_RUNNERS = [
    InterpretedCodeRunner.new('ruby', 'rb')
  ]
end