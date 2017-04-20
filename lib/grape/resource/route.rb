module Grape
  module Resource
    class Route

      AVAILABLE_METHODS = [:index, :create, :show, :update, :delete]

      class << self

        # class attributes
        attr_reader :collection_endpoints
        attr_reader :member_endpoints

        # ===== Examples
        #
        #   class PostsRoute < Grape::Resource::Route
        #     route_for Post, as: :posts, only: :index, :except: :index
        #   end
        def route_for(resource_class, **args)
          define_method :routing_options do
            { for: resource_class }.merge(args)
          end
        end

        # ===== Examples
        #
        #   class PostsRoute < Grape::Resource::Route
        #     post :publish do
        #       record.publish!
        #       record
        #     end
        #   end
        %w(get post put delete).each do |method|
          define_method method do |*args, &block|
            path = args.any? ? args.first : nil
            create_endpoint(method, path, &block)
          end
        end

        def create_endpoint(method, path, &block)
          @collection_endpoints = (@collection_endpoints || []).push(
            [method, path, block]
          )
        end
      end

      attr_reader :routing_options

      def initialize(**options)
        @routing_options = options if options.any?
      end

      def grape_route_class
        handler     = self
        cls         = resource_class
        cls_alias   = resource_alias
        param_alias = resource_param_alias
        r_methods   = resource_methods

        # class_eval <<-RUBY, __FILE__, __LINE__+1
        Class.new(Grape::API) do
          namespace cls_alias do
            
            helpers do
              def resource_route
                handler
              end

              def record_params
                params[handler.param_alias]
              end
            end

            handler.collection_endpoints.each do |method, name, &block|
              self.send(method, name, &block)
            end

            if [:show, :update, :delete].any?{ |m| r_methods.include?(m) }
              route_param :id do
                if r_methods.include?(:show)
                  get do
                    resource_route.resource_class.find(params[:id])
                  end
                end

                if r_methods.include?(:update)
                  put do
                    record = cls.find(params[:id])
                    record.update!(record_params)
                    record
                  end
                end

                if r_methods.include?(:delete)
                  delete do
                    record = cls.find(params[:id])
                    record.destroy!
                    record
                  end
                end
              end
            end

          end
        end
        # RUBY
      end

      def resource_param_alias
        resource_alias.to_s.singularize.to_sym
      end

      def resource_class
        routing_options.fetch(:for)
      end

      def resource_alias
        routing_options.fetch(:as, resource_class.to_s.underscore.pluralize.to_sym)
      end

      def only_routing
        @only_routing ||= Array(routing_options.fetch(:only, []))
          .select { |m| AVAILABLE_METHODS.include?(m) }
      end

      def except_routing
        @except_routing ||= Array(routing_options.fetch(:except, []))
          .select { |m| AVAILABLE_METHODS.include?(m) }
      end

      def resource_methods
        @resource_methods ||= if only_routing.any?
          only_routing
        elsif except_routing.any?
          AVAILABLE_METHODS - except_routing
        else
          AVAILABLE_METHODS
        end        
      end

      def collection_endpoints
        @collection_endpoints ||= default_collection_endpoints + Array(self.class.collection_endpoints)
      end

      def default_collection_endpoints
        [].tap do |c|
          c << build_index_endpoint  if resource_methods.include?(:index)
          c << build_create_endpoint if resource_methods.include?(:create)
        end
      end

      def build_index_endpoint
        build_endpoint :get, nil do
          resource_route.resource_class.all
        end
      end

      def build_create_endpoint
        build_endpoint :post, nil do
          resource_route.resource_class.new(record_params).save!
        end
      end

      def build_endpoint(method, path, &block)
        [method, path, block]
      end
    end
  end
end
