require 'sinatra/base'

class SampleApp < Sinatra::Base

  get('/') { 'Ruby Docker Container' }

end

run SampleApp