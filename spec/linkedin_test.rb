require 'rspec'
require 'rack/test'
require '../linked_in.rb'


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
    end
  end

end