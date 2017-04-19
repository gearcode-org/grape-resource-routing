module Grape
  module Extensions
    module ResourceMounter

      # ===== Examples
      #
      #   class API < Grape::API
      #     mount_resource Post
      #   end
      def mount_resource(resource_class)

        route_class = Class.new(Grape::API) do
          namespace resource_class.to_s.underscore.pluralize.to_sym do
            
            helpers do
              def record_params
                params[resource_class.to_s.underscore.to_sym]
              end
            end

            get do
              resource_class.all
            end

            post do
              resource_class.new(record_params).save!
            end

            route_param :id do
              get do
                resource_class.find(params[:id])
              end

              put do
                record = resource_class.find(params[:id])
                record.update!(record_params)
                record
              end

              delete do
                record = resource_class.find(params[:id])
                record.destroy!
                record
              end
            end
          end
        end
        
        mount(route_class)
      end
    end
  end
end

Grape::API.extend(Grape::Extensions::ResourceMounter)
