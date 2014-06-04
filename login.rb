require 'sinatra'


class Login < Sinatra::Base

  get '/' do
    erb :home
  end

  get '/login' do
    redirect to "https://www.linkedin.com/uas/oauth2/authorization?response_type=code&client_id=75gdtd4stlhdda&scope=r_fullprofile%20r_emailaddress%20r_network%rw_groups%rw_company_admin%rw_nus&state=DCEEFWF45453sdffef424}&redirect_uri=http://localhost:3000/callback"
  end

end