require_relative './spec_helper'

require 'json'
require 'tempfile'

describe CodeRunnerApp do
  describe "POST /" do
    it "should report missing `code' parameter" do
      post '/'

      json_response = JSON.parse(last_response.body)

      expect(last_response.status).to eq(400)
      expect(json_response['success']).to eq(false)
      expect(json_response['error']).to eq("Missing `code' or `zip_file' parameter. ")
    end

    it "should give correct outputs and status code" do
      @tmpfile = Tempfile.new(['test', '.rb'])
      @tmpfile.write("puts 'Hello, world! '; STDERR.puts 'error'; exit(3)")
      @tmpfile.close

      post '/', code: Rack::Test::UploadedFile.new(@tmpfile.path)

      json_response = JSON.parse(last_response.body)

      expect(last_response.status).to eq(200)
      expect(json_response['success']).to eq(true)
      expect(json_response['stdout']).to eq("Hello, world! \n")
      expect(json_response['stderr']).to eq("error\n")
      expect(json_response['status']).to eq(3)
    end

    it 'should be able to run zipfile with makefiles in the root directory' do
      zipfile = create_zip_file({
        'test.rb' => 'puts "Hello"; $stderr.puts "error"', 
        'makefile' => "run:\n\t@ruby test.rb"
      })

      post '/', zip_file: Rack::Test::UploadedFile.new(zipfile)

      json_response = JSON.parse(last_response.body)

      expect(last_response.status).to eq(200)
      expect(json_response['success']).to eq(true)
      expect(json_response['stdout']).to eq("Hello\n")
      expect(json_response['stderr']).to match(/error\n/)
    end

    it "should report unsupported file types" do
      @tmpfile = Tempfile.new(['test', '.something_weird'])
      @tmpfile.close

      post '/', code: Rack::Test::UploadedFile.new(@tmpfile.path)

      json_response = JSON.parse(last_response.body)

      expect(last_response.status).to eq(400)
      expect(json_response['success']).to eq(false)
      expect(json_response['error']).to eq("File type not supported yet. ")
    end
  end
end