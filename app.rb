# Add `lib' directory to the load path.
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib'))

require 'sinatra/base'
require 'tempfile'
require 'json'

require 'code_runner'

class CodeRunnerApp < Sinatra::Base
  @@runner = CodeRunner.new

  post '/' do
    content_type :json

    if (params['code'].nil? || params['code'][:filename].nil?) &&
       (params['zip_file'].nil? || params['zip_file'][:filename].nil?)
      status 400
      body ({success: false, error: "Missing `code' or `zip_file' parameter. "}).to_json
      return
    end

    begin
      result = @@runner.run((params['code'] || params['zip_file'])[:tempfile].path)

      status 200
      body result.merge({success: true}).to_json
      return
    rescue CodeRunner::NoCompatibleRunner => e
      status 400
      body ({success: false, error: "File type not supported yet. "}).to_json
      return
    end
  end
end