require 'filter8'
require 'rspec'
require 'timecop'

RSpec.configure do |config|

  config.after(:each) do
    Timecop.return
  end

end