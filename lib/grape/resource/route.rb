module Grape
  module Resource
    class Route
      class << self
        # ===== Examples
        #
        #   class PostsRoute < Grape::Resource::Route
        #     route_for Post, as: :posts
        #   end
        def route_for(resource_class, args={})
          # class_eval <<-RUBY, __FILE__, __LINE__+1
          # RUBY
          define_method :resource_class do
            resource_class
          end

          define_method :resource_class_alias do
            args.fetch(:as, resource_class.to_s.underscore.pluralize.to_sym)
          end
        end
      end

      attr_reader :resource_class
      attr_reader :resource_class_alias

      def initialize(**options)
        @resource_class = options.fetch(:for, nil)
        @resource_class_alias = options.fetch(:as, nil)
      end

      def grape_route_class
        cls         = resource_class
        cls_alias   = resource_class_alias
        param_alias = resource_param_alias

        route_class = Class.new(Grape::API) do
          namespace cls_alias do
            
            helpers do
              def record_params
                params[param_alias]
              end
            end

            get do
              cls.all
            end

            post do
              cls.new(record_params).save!
            end

            route_param :id do
              get do
                cls.find(params[:id])
              end

              put do
                record = cls.find(params[:id])
                record.update!(record_params)
                record
              end

              delete do
                record = cls.find(params[:id])
                record.destroy!
                record
              end
            end
          end
        end
      end

      def resource_param_alias
        resource_class_alias.to_s.singularize.to_sym
      end
    end
  end
end
