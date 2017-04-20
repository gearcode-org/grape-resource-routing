module Grape
  module Extensions
    module ResourceMounter

      # ===== Examples
      #
      #   class API < Grape::API
      #     mount_resource PostsRoute, for: Post, as: :posts
      #     
      #     mount_resource do
      #       route_for Post, as: :posts, only: :index
      #     end
      #   end
      def mount_resource(resource_route = nil, **args, &block)
        if not resource_route and block_given?
          resource_route = Class.new(Grape::Resource::Route, &block)
        end
        mount(resource_route.new(args).grape_route_class)
      end
    end
  end
end

Grape::API.extend(Grape::Extensions::ResourceMounter)
