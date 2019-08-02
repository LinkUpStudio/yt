module Yt
  module Models
    class Whitelist < Base
      attr_reader :auth

      def initialize(options = {})
        @data = options.fetch(:data, {})
        @auth = options[:auth]
      end

      # @return [String] The YouTube channel ID that uniquely identifies the
      #   whitelisted channel.
      has_attribute :id

      # @return [String] The whitelisted YouTube channel's title.
      has_attribute :title

      def delete
        do_delete
        self
      end

      private

      def modify_params
        super.tap do |params|
          params[:path] = "/youtube/partner/v1/whitelists/#{id}"
          params[:params] = { on_behalf_of_content_owner: @auth.owner_name }
        end
      end
    end
  end
end
