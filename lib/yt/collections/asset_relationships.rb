require 'yt/collections/base'

module Yt
  module Collections
    class AssetRelationships < Base

      def insert(attributes = {})
        params = { on_behalf_of_content_owner: @auth.owner_name }
        attributes[:parent_asset_id] = @parent.id
        do_insert(params: params, body: attributes)
      end

    private
      def new_item(data)
      #   klass = (data["kind"] == "youtubePartner#assetSnippet") ? Yt::Asset : Yt::Asset
        Yt::AssetRelationship.new attributes_for_new_item(data)
      end

      # @return [Hash] the parameters to submit to YouTube to list assets
      #   owned by the content owner.
      # @see https://developers.google.com/youtube/partner/docs/v1/assets/list
      def list_params
        super.tap do |params|
          params[:path] = '/youtube/partner/v1/assetRelationships'
          params[:params] = asset_relationship_params
          puts 'B'*30
          puts params.inspect
          puts 'B'*30
        end
      end

      def asset_relationship_params
        apply_where_params!(on_behalf_of_content_owner: @auth.owner_name, asset_id: @parent.id)
      end

      # @return [Hash] the parameters to submit to YouTube to add a asset.
      # @see https://developers.google.com/youtube/partner/docs/v1/assets/insert
      def insert_params
        super.tap do |params|
          params[:path] = '/youtube/partner/v1/assetRelationships'
        end
      end
    end
  end
end
