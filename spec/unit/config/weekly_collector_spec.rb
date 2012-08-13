require_relative "../spec_helper"

describe "Date Range" do

  class Dummy
    include GoogleAnalytics::Config::WeeklyCollector
    def initialize start_at, end_at
      @start_at, @end_at = start_at, end_at
    end

    attr_reader :start_at, :end_at
  end

  it "should create a range for the last week" do
    on_tuesday = Dummy.last_before(Date.new(2012, 8, 9))

    on_tuesday.start_at.should eql(Date.new(2012, 7, 29))
    on_tuesday.end_at.should eql(Date.new(2012, 8, 4))
  end

  it "should go back to last saturday, if passed date is a saturday" do
    on_saturday = Dummy.last_before(Date.new(2012, 3, 17))

    on_saturday.start_at.should eql(Date.new(2012, 3, 4))
    on_saturday.end_at.should eql(Date.new(2012, 3, 10))
  end
end