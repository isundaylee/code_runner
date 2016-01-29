require 'rack/test'
require 'rspec'

require 'tempfile'

require_relative '../app.rb'

ENV['RACK_ENV'] = 'test'

module RSpecMixin
  include Rack::Test::Methods

  def app()
    CodeRunnerApp
  end
end

module ZipFileHelpers
  def create_zip_file(files)
    @tmp_zip = Tempfile.new(['test', '.zip'])
    @tmp_zip.close

    ::Zip::File.open(@tmp_zip.path, Zip::File::CREATE) do |zip|
      files.each do |name, content|
        zip.get_output_stream(name) { |os| os.write(content) }
      end
    end

    @tmp_zip.path
  end
end

# For RSpec 2.x and 3.x
RSpec.configure do |c|
  c.include RSpecMixin
  c.include ZipFileHelpers
end