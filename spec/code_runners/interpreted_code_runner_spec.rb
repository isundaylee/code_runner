require 'spec_helper'
require 'tempfile'

require 'code_runners/interpreted_code_runner'

describe InterpretedCodeRunner do
  before do
    # If you are running this test suite, chances are you have ruby installed ;)
    @runner = InterpretedCodeRunner.new('ruby', 'rb')
  end

  describe '#initialize' do
    it "should raise EnvironmentError for unavailable interpreter" do
      expect { InterpretedCodeRunner.new('nonexistent', 'ne') }.to raise_error(InterpretedCodeRunner::EnvironmentError)
    end
  end

  describe '#accepts_filename?' do
    it 'should accept valid names' do
      expect(@runner.accepts_filename?('abc.rb')).to eq(true)
      expect(@runner.accepts_filename?('../abc.rb')).to eq(true)
      expect(@runner.accepts_filename?('./abc.rb')).to eq(true)
      expect(@runner.accepts_filename?('/tmp/something_else/abc.rb')).to eq(true)
    end

    it 'should reject invalid names' do
      expect(@runner.accepts_filename?('abc.py')).to eq(false)
      expect(@runner.accepts_filename?('abc')).to eq(false)
      expect(@runner.accepts_filename?('/tmp/a/abc.py')).to eq(false)
      expect(@runner.accepts_filename?('../abc.py')).to eq(false)
    end
  end

  describe '#run' do
    before do
      @tmpfile = Tempfile.new(['test', '.rb'])
    end

    it 'should give correct stdout output' do
      @tmpfile.write('puts "Hello, world! "')
      @tmpfile.close

      expect(@runner.run(@tmpfile.path)[:stdout]).to eq("Hello, world! \n")
    end

    it 'should give correct stderr output' do
      @tmpfile.write('STDERR.puts "Something has happened"')
      @tmpfile.close

      expect(@runner.run(@tmpfile.path)[:stderr]).to eq("Something has happened\n")
    end

    it 'should give correct status code upon exiting normally' do
      @tmpfile.write('')
      @tmpfile.close

      expect(@runner.run(@tmpfile.path)[:status]).to eq(0)
    end

    it 'should give correct status code upon exiting with error' do
      @tmpfile.write('exit(123)')
      @tmpfile.close

      expect(@runner.run(@tmpfile.path)[:status]).to eq(123)
    end
  end
end