module GoogleAnalytics
  module Config
    class Base

      def self.descendants
        ObjectSpace.each_object(Class).select{|klass| klass < self }.map{|klass| klass.name.split("::").last}
      end

      def initialize reference_date
        @reference_date = reference_date
      end

      GOOGLE_ANALYTICS_URL_ID = "ga:53872948"

      def analytics_parameters()
        parameters = {}

        parameters["ids"] = self.class::GOOGLE_ANALYTICS_URL_ID
        parameters["start-date"] = start_at.strftime
        parameters["end-date"] = end_at.strftime
        parameters["metrics"] = self.class::METRIC
        parameters["dimensions"] = self.class::DIMENSION

        parameters
      end

      def amqp_topic
        self.class::AMQP_TOPIC
      end
    end
  end
end