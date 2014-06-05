require 'rspec'
require 'rack/test'
require '../linked_in.rb'
require 'vcr'
require 'webmock/rspec'

VCR.configure do |c|
  c.cassette_library_dir = 'fixtures/vcr_cassettes'
  c.hook_into :webmock
end

RSpec.configure do |c|
  c.around(:each) do |example|
    VCR.use_cassette(example.metadata[:full_description]) do
      example.run
    end
  end
end

describe LinkedIn do
  include Rack::Test::Methods

  def app
    LinkedIn
  end

  describe LinkedIn do
    describe 'with authorization test' do
      it 'should redirect to /callback' do
        get '/callback'
        expect last_response.status == 302
      end

      it 'should return profile fields' do
        get '/full_info'
        expect last_response.status == 200
      end

      it 'should return user email' do
        get '/email'
        expect last_response.status == 200
      end

      it 'should return user connections' do
        get '/connections'
        expect last_response.status == 200
      end

      it 'should get user page updates' do
        get '/retrieve_updates'
        expect last_response.status == 200
      end

      it 'should return new discussions' do
        get '/retrieve_discussions'
        expect last_response.status == 200
      end

      it 'should return body' do
        res = stub_request :get, '/callback'
        get '/callback'
        expect last_response == res
      end
    end
  end

end