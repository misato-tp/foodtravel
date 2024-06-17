RSpec.configure do |config|
  config.before(:each, type: :system) do |example|
    if example.metadata[:js]
      driven_by :selenium_chrome, screen_size: [1400, 1400]
    else
      driven_by :rack_test
    end
  end
end
