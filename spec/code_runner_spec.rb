require_relative './spec_helper'

require 'tempfile'

describe CodeRunner do
  before do
    @runner = CodeRunner.new
  end

  describe '#run' do
    it 'should be able to run Ruby code' do
      @tmpfile = Tempfile.new(['test', '.rb'])
      @tmpfile.write("puts 'Hello, world! '; STDERR.puts 'error'; exit(3)")
      @tmpfile.close

      result = @runner.run(@tmpfile.path)

      expect(result[:stdout]).to eq("Hello, world! \n")
      expect(result[:stderr]).to eq("error\n")
      expect(result[:status]).to eq(3)
    end

    it 'should be able to run Python code' do
      @tmpfile = Tempfile.new(['test', '.py'])
      @tmpfile.write("print('Hello, world! ')")
      @tmpfile.close

      result = @runner.run(@tmpfile.path)

      # We only test stdout here, as stderr and status has enough coverage already.
      expect(result[:stdout]).to eq("Hello, world! \n")
    end
  end
end
