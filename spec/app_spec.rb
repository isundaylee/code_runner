require_relative './spec_helper'

describe CodeRunnerApp do
  describe "POST /" do
    it "should return `Hello, world! '" do
      post '/'
      expect(last_response).to be_ok
      expect(last_response.body).to eq('Hello, world! ')
    end
  end
end