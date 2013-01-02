require_relative "spec_helper"

describe "Weekly visits collector" do
  before(:each) do
    stub_credentials
    register_oauth_refresh
    register_api_discovery
  end

  it "should query google analytics for specific dates" do
    register_ga_request(
      {
        :ids => "ga:53872948",
        :"start-date" => "2012-12-23",
        :"end-date" => "2012-12-29",
        :metrics => "ga:visits",
        :dimensions => "ga:week"
      },
      load_data("weekly-visits-from-2012-12-23.json")
    )

    collector = GoogleAnalytics::Collector.new(nil, [GoogleAnalytics::Config::WeeklyVisits.new(Date.new(2012, 12, 23), Date.new(2012, 12, 29))])

    response = collector.collect_as_json
    response.should have(1).item

    response[0].should be_for_collector("Google Analytics")
    response[0].should be_for_time_period(
                         Date.new(2012, 12, 23), Date.new(2012, 12, 30))
    response[0].should have_payload_value(
                         "visits" => 3291103, "site" => "govuk")

  end

  it "should query google analytics for last week today" do
    register_ga_request(
      {
        :dimensions => "ga:week",
        :"end-date" => "2012-12-29",
        :ids => "ga:53872948",
        :metrics => "ga:visitors",
        :"start-date" => "2012-12-23"
      },
      load_data("weekly-visitors-from-2012-12-23.json")
    )

    Timecop.travel(DateTime.parse("2012-12-31")) do
      collector = GoogleAnalytics::Collector.new(nil, GoogleAnalytics::Config::WeeklyVisits.all_within(Date.today - 1, Date.today))

      response = collector.collect_as_json
      response.should have(1).item

      response[0].should be_for_time_period(
                           Date.new(2012, 12, 23), Date.new(2012, 12, 30))
      response[0].should have_payload_value(
                           "visits" => 3291103, "site" => "govuk")
    end
  end

  it "should query google analytics for the previous three weeks" do
    register_ga_request(
      {
        :dimensions => "ga:week",
        :"end-date" => "2012-12-29",
        :ids => "ga:53872948",
        :metrics => "ga:visits",
        :"start-date" => "2012-12-23"
      },
      load_data("weekly-visits-from-2012-12-23.json")
    )
    register_ga_request(
      {
        :dimensions => "ga:week",
        :"end-date" => "2012-12-22",
        :ids => "ga:53872948",
        :metrics => "ga:visits",
        :"start-date" => "2012-12-16"
      },
      load_data("weekly-visits-from-2012-12-16.json")
    )
    register_ga_request(
      {
        :dimensions => "ga:week",
        :"end-date" => "2012-12-15",
        :ids => "ga:53872948",
        :metrics => "ga:visits",
        :"start-date" => "2012-12-09"
      },
      load_data("weekly-visits-from-2012-12-09.json")
    )
    Timecop.travel(DateTime.parse("2012-12-31")) do
      collector = GoogleAnalytics::Collector.new(nil,
                                                 GoogleAnalytics::Config::WeeklyVisits.all_within(Date.new(2012, 12, 10), Date.today)
      )

      response = collector.collect_as_json
      response.should have(3).items

      response[0].should be_for_time_period(
                           Date.new(2012, 12, 9), Date.new(2012, 12, 16))
      response[0].should have_payload_value(
                           "visits" => 5760192, "site" => "govuk")

      response[1].should be_for_time_period(
                           Date.new(2012, 12, 16), Date.new(2012, 12, 23))
      response[1].should have_payload_value(
                           "visits" => 5341780, "site" => "govuk")

      response[2].should be_for_time_period(
                           Date.new(2012, 12, 23), Date.new(2012, 12, 30))
      response[2].should have_payload_value(
                           "visits" => 3291103, "site" => "govuk")
    end
  end
end