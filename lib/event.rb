require 'time'

class Event < ActiveRecord::Base

  validates :description, presence: true
  validates :start_timestamp, presence: true
  validates :end_timestamp, presence: true

  def self.upcoming 
    order('start_timestamp').where("start_timestamp > ?", (Time.now - 7.hour))
  end

  def self.today
    order('start_timestamp').where(start_timestamp: (Time.now.midnight - 7.hour)..(Time.now.midnight + 1.day - 7.hour))
  end

  def self.between(start_date, end_date)
    order('start_timestamp').where(start_timestamp: (Time.parse(start_date) - 7.hour)..(Time.parse(end_date) + 1.day - 7.hour))
  end

end