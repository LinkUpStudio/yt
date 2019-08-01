module Yt
  module Models
    class Whitelist < Base
      attr_reader :auth

      def initialize(options = {})
        @data = options.fetch(:data, {})
        @id = options[:id]
        @auth = options[:auth]
      end

      # @return [String] The YouTube channel ID that uniquely identifies the
      #   whitelisted channel.
      has_attribute :id

      # @return [String] The whitelisted YouTube channel's title.
      has_attribute :title
    end
  end
end
