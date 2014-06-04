require './linked_in.rb'
require './login.rb'

run Rack::Cascade.new [Login, LinkedIn]