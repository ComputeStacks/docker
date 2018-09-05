require 'sinatra/base'

class SampleApp < Sinatra::Base

  get('/') { '<h4>Ruby Docker Container</h4><p><a href="https://www.notion.so/computestacks/Ruby-Container-8bd2aaab3c7d4d7fa8bb86c83d56b518" target="_blank">Click here</a> to view documentation on how to use this container.</p>' }

end

run SampleApp