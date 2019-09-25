module Yt
  module Models
    class AssetRelationship < Base
      attr_reader :auth, :id

      def initialize(options = {})
        @data = options.fetch(:data, {})
        @id = @data['id']
        @auth = options[:auth]
      end

      def delete
        do_delete
        self
      end

      private

      def modify_params
        super.tap do |params|
          params[:path] = "/youtube/partner/v1/assetRelationships/#{id}"
          params[:params] = { on_behalf_of_content_owner: auth.owner_name }
        end
      end
    end
  end
end
