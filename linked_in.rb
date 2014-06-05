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

  def self.fetch_response(scope)
    uri = URI("https://api.linkedin.com/v1/#{scope}?format=json&oauth2_access_token=#{@@token}")
    res = Net::HTTP.get_response(uri)
    res.body
  end

  # r_fullprofile
  get :full_info do
    url_part = 'people/~'
    res = LinkedIn.fetch_response(url_part)
    hash = JSON.parse(res)
    obj = Hashie::Mash.new(hash)
  end

  # r_emailaddress
  get :email do
    url_part = 'people/~/email-address'
    res = LinkedIn.fetch_response(url_part)
    res.gsub(/[\/"]*/, '')
  end

  # r_network
  get :connections do
    url_part = 'people/~/connections'
    res = LinkedIn.fetch_response(url_part)
    str = res.force_encoding('UTF-8')
    hash = JSON.parse(str)
    obj = Hashie::Mash.new(hash)
  end

  # rw_nus only GET
  get :retrieve_updates do
    url_part = 'people/~/network/updates'
    res = LinkedIn.fetch_response(url_part)
    str = res.force_encoding('UTF-8')
    hash = JSON.parse(str)
    obj = Hashie::Mash.new(hash)
  end

  # rw_groups only GET
  get :retrieve_discussions do
    url_part = 'people/~/group-memberships'
    res = LinkedIn.fetch_response(url_part)
    hash = JSON.parse(res)
    obj = Hashie::Mash.new(hash)
  end

end