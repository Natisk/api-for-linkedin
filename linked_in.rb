require 'grape'
require 'json'
require 'hashie'


class LinkedIn < Grape::API

  version 'v1', using: :header, vendor: 'linked_in'
  format :json

  get :callback do
    code = params[:code]
    uri = URI('https://www.linkedin.com/uas/oauth2/accessToken')
    res = Net::HTTP.post_form(uri,
                              grant_type: 'authorization_code',
                              code: code,
                              redirect_uri: 'http://localhost:3000/callback',
                              client_id: '75gdtd4stlhdda',
                              client_secret: 'yJm2Fh2JgjIKNN9N')
    @@token = JSON.parse(res.body.gsub('=>', ':'))['access_token']

    redirect '/full_info'
  end

  # r_fullprofile
  get :full_info do
    uri = URI("https://api.linkedin.com/v1/people/~?format=json&oauth2_access_token=#{@@token}")
    res = Net::HTTP.get_response(uri)
    # j_str = res.body
    hash = JSON.parse(res.body)
    obj = Hashie::Mash.new(hash)
  end

  # r_emailaddress
  get :email do
    uri = URI("https://api.linkedin.com/v1/people/~/email-address?format=json&oauth2_access_token=#{@@token}")
    res = Net::HTTP.get_response(uri)
    res.body.gsub(/[\/"]*/, '')
  end

  # r_network
  get :connections do
    uri = URI("https://api.linkedin.com/v1/people/~/connections?format=json&oauth2_access_token=#{@@token}")
    res = Net::HTTP.get_response(uri)
    str = res.body.force_encoding('UTF-8')
    hash = JSON.parse(str)
    obj = Hashie::Mash.new(hash)
  end

  # rw_nus only GET
  get :retrieve_updates do
    uri = URI("https://api.linkedin.com/v1/people/~/network/updates?format=json&oauth2_access_token=#{@@token}")
    res = Net::HTTP.get_response(uri)
    res.body.force_encoding('UTF-8')
    hash = JSON.parse(str)
    obj = Hashie::Mash.new(hash)
  end

  # rw_groups only GET
  get :retrieve_discussions do
    uri = URI("https://api.linkedin.com/v1/people/~/group-memberships?format=json&oauth2_access_token=#{@@token}")
    res = Net::HTTP.get_response(uri)
    hash = JSON.parse(res.body)
    obj = Hashie::Mash.new(hash)
  end

end