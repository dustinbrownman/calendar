require 'spec_helper'

describe Event do
  it { should validate_presence_of :description }

  it { should validate_presence_of :start_timestamp }

  it { should validate_presence_of :end_timestamp }

  describe '.upcoming' do
    it 'returns all the upcoming events in order' do
      time_now = Time.parse("2013-09-19 12:00")
      Time.stub(:now) {time_now}
      event_a = Event.create(description: 'event_a', start_timestamp: "2013-09-19 10:00", end_timestamp: "2013-09-19 10:00")
      event_b = Event.create(description: 'event_b', start_timestamp: "2013-09-19 12:30", end_timestamp: "2013-09-19 12:30")
      event_c = Event.create(description: 'event_c', start_timestamp: "2013-09-19 14:00", end_timestamp: "2013-09-19 14:00")
      Event.upcoming.should eq [event_b, event_c]
    end
  end

  describe '.today' do
    it 'returns all the events for the current day' do
      time_now = Time.parse("2013-09-19 12:00")
      Time.stub(:now) {time_now}
      event_a = Event.create(description: 'event_a', start_timestamp: "2013-09-19 01:00", end_timestamp: "2013-09-19 01:00")
      event_b = Event.create(description: 'event_b', start_timestamp: "2013-09-19 12:30", end_timestamp: "2013-09-19 12:30")
      event_c = Event.create(description: 'event_c', start_timestamp: "2013-09-20 23:00", end_timestamp: "2013-09-20 23:00")
      Event.today.should eq [event_a, event_b]
    end
  end

  describe '.between' do
    it 'returns all events for a given date range' do
      event_a = Event.create(description: 'event_a', start_timestamp: "2013-09-24 10:00", end_timestamp: "2013-09-24 10:00")
      event_b = Event.create(description: 'event_b', start_timestamp: "2013-10-19 12:30", end_timestamp: "2013-10-19 12:30")
      event_c = Event.create(description: 'event_c', start_timestamp: "2013-11-20 14:00", end_timestamp: "2013-11-20 14:00")
      Event.between('2013-09-10', '2013-10-20').should eq [event_a, event_b]
    end

    it 'is inclusive of events on the end date' do
      event_a = Event.create(description: 'event_a', start_timestamp: "2013-09-24 10:00", end_timestamp: "2013-09-24 10:00")
      event_b = Event.create(description: 'event_b', start_timestamp: "2013-10-19 12:30", end_timestamp: "2013-10-19 12:30")
      Event.between('2013-09-10', '2013-10-19').should eq [event_a, event_b]
    end
  end
end