require 'active_record'
require 'time'
require 'rspec'
require 'shoulda-matchers'
require 'pry'
require 'event'
require 'todo'
require 'note'

ActiveRecord::Base.establish_connection(YAML::load(File.open('./db/config.yml'))['test'])

RSpec.configure do |config|
  config.after(:each) do
    Event.all.each { |event| event.destroy }
    Todo.all.each { |todo| todo.destroy }
  end
end
