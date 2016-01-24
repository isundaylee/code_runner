# Add `lib' directory to the load path.
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib'))

require 'sinatra/base'

require 'code_runner'

class CodeRunnerApp < Sinatra::Base
  post '/' do
    ["Hello, world! "]
  end
end