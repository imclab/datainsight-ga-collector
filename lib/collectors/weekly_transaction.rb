require_relative "config/base"
require_relative "config/weekly_collector"
require_relative "../../lib/response/weekly_entry_success_response"

module GoogleAnalytics
  module Config
    class WeeklyTransaction < Base
      include WeeklyCollector

      GOOGLE_ANALYTICS_URL_ID = %w(ga:53872948 ga:61976178)
      AMQP_TOPIC = "google_analytics.entry_and_success.weekly"
      SITE_KEY = "govuk"

      DIMENSION = DIMENSION + ",ga:eventCategory,ga:eventLabel"
      METRIC = "ga:totalEvents"
      CATEGORY_PREFIX = 'MS_'
      FILTERS = "ga:eventCategory==MS_transaction"
      RESPONSE_TYPE = GoogleAnalytics::WeeklyEntrySuccessResponse

      def analytics_parameters()
        self.class::GOOGLE_ANALYTICS_URL_ID.map do |id|
          build_parameters_for(id: id)
        end
      end
    end
  end
end
