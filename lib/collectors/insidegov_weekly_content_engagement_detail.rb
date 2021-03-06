require_relative "../response/weekly_content_engagement_detail_response"

module GoogleAnalytics
  module Config
    class InsideGovWeeklyContentEngagementDetail < Base
      include WeeklyCollector

      GOOGLE_ANALYTICS_URL_ID = GOVUK_PROFILE_ID
      AMQP_TOPIC = "google_analytics.insidegov.content_engagement.weekly"
      SITE_KEY = "govuk"

      DIMENSION = "ga:eventCategory,ga:eventAction,ga:eventLabel"
      METRIC = "ga:totalEvents"
      CATEGORY_PREFIX = "IG_"
      FILTERS= "ga:eventCategory=~^#{CATEGORY_PREFIX}.*"
      RESPONSE_TYPE = GoogleAnalytics::WeeklyContentEngagementDetailResponse
    end
  end
end