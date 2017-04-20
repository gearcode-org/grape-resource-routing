module Grape
  module Extensions
    module ResourceMounter

      # ===== Examples
      #
      #   class API < Grape::API
      #     mount_resource PostsRoute
      #   end
      def mount_resource(resource_route, **args)
        mount(resource_route.new(args).grape_route_class)
      end
    end
  end
end

Grape::API.extend(Grape::Extensions::ResourceMounter)
