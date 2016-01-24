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
      expect(json_response['error']).to eq("Missing `code' parameter. ")
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