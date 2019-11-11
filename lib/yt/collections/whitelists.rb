require 'yt/collections/base'

module Yt
  module Collections
    class Whitelists < Base
      def insert(attributes = {})
        params = { on_behalf_of_content_owner: @auth.owner_name }

        do_insert(params: params, body: attributes)
      end

      private

      def new_item(data)
        Yt::Whitelist.new attributes_for_new_item(data)
      end

      def list_params
        super.tap do |params|
          params[:path] = path
          params[:params] = whitelist_params
        end
      end

      def whitelist_params
        apply_where_params!(on_behalf_of_content_owner: @auth.owner_name)
      end

      def insert_params
        super.tap do |params|
          params[:path] = path
        end
      end

      def path
        '/youtube/partner/v1/whitelists'
      end
    end
  end
end
