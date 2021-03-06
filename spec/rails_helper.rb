ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)

abort("The Rails environment is running in production mode!") if Rails.env.production?

require 'spec_helper'
require 'rspec/rails'
require 'webmock/rspec'
require 'paperclip/matchers'

ActiveRecord::Migration.maintain_test_schema!
WebMock.disable_net_connect!(allow: 'localhost:7575')
Sidekiq::Testing.inline!

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = true
  config.order = 'random'
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!

  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include Devise::TestHelpers, type: :view
  config.include Paperclip::Shoulda::Matchers
end

RSpec::Sidekiq.configure do |config|
  config.warn_when_jobs_not_processed_by_sidekiq = false
end

def request_fixture(name)
  File.read(File.join(Rails.root, 'spec', 'fixtures', 'requests', name))
end

def attachment_fixture(name)
  File.open(File.join(Rails.root, 'spec', 'fixtures', 'files', name))
end
