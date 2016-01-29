require 'spec_helper'
require 'tempfile'

require 'code_runners/make_code_runner'

describe MakeCodeRunner do
  before do
    @runner = MakeCodeRunner.new
  end

  describe '#accepts_zipfile?' do
    it 'should accept zip files with makefiles in the root directory' do
      zipfile = create_zip_file({
        'makefile' => '', 
        'test.rb' => ''
      })

      expect(@runner.accepts_zipfile?(zipfile)).to eq(true)
    end

    it 'should not accept zip files without makefiles in the root directory' do
      zipfile = create_zip_file({
        'somewhere/makefile' => '', 
        'test.rb' => ''
      })

      expect(@runner.accepts_zipfile?(zipfile)).to eq(false)
    end
  end

  describe '#run' do
    it 'should give the correct outputs' do
      zipfile = create_zip_file({
        'test.rb' => 'puts "Hello"; $stderr.puts "error"', 
        'makefile' => "run:\n\t@ruby test.rb"
      })

      result = @runner.run(zipfile)

      expect(result[:stdout]).to eq("Hello\n")
      expect(result[:stderr]).to match(/error\n/)
    end
  end
end