require 'yt/collections/resources'

module Yt
  module Collections
    # Provides methods to interact with a collection of YouTube channels.
    #
    # Resources with channels are: {Yt::Models::Account accounts}.
    class Channels < Resources

    private

      def attributes_for_new_item(data)
        super(data).tap do |attributes|
          attributes[:id] = data['id']['channelId'] if use_search_endpoint?
          attributes[:statistics] = data['statistics']
          attributes[:content_owner_details] = data['contentOwnerDetails']
          attributes[:branding_settings] = data['brandingSettings']
        end
      end

      # @return [Hash] the parameters to submit to YouTube to list channels.
      # @see https://developers.google.com/youtube/v3/docs/channels/list
      def list_params
        super.tap do |params|
          params[:path] = channels_path
          params[:params] = channels_params
        end
      end

      def channels_path
        if use_list_endpoint?
          '/youtube/v3/channels'
        else
          '/youtube/v3/search'
        end
      end

      def channels_params
        params = resources_params
        params.merge! mine: true if @parent
        params.merge!(part: :snippet, type: :channel) if use_search_endpoint?
        apply_where_params! params
      end

      def use_search_endpoint?
        !use_list_endpoint?
      end

      def use_list_endpoint?
        @where_params ||= {}
        (@where_params.keys & %i[id for_username]).any?
      end
    end
  end
end
