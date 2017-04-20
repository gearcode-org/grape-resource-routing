module Grape
  module Resource
    class Route

      AVAILABLE_METHODS = [:index, :create, :show, :update, :delete]

      class << self
        # ===== Examples
        #
        #   class PostsRoute < Grape::Resource::Route
        #     route_for Post, as: :posts, only: :index, :except: :index
        #   end
        def route_for(resource_class, **args)
          # class_eval <<-RUBY, __FILE__, __LINE__+1
          # RUBY
          define_method :routing_options do
            { for: resource_class }.merge(args)
          end
        end
      end

      attr_reader :routing_options

      def initialize(**options)
        @routing_options = options if options.any?
      end

      def grape_route_class
        cls         = resource_class
        cls_alias   = resource_alias
        param_alias = resource_param_alias
        r_methods   = resource_methods

        route_class = Class.new(Grape::API) do
          namespace cls_alias do
            
            helpers do
              def record_params
                params[param_alias]
              end
            end

            if r_methods.include?(:index)
              get do
                cls.all
              end
            end

            if r_methods.include?(:create)
              post do
                cls.new(record_params).save!
              end
            end

            if [:show, :update, :delete].any?{ |m| r_methods.include?(m) }
              route_param :id do
                if r_methods.include?(:show)
                  get do
                    cls.find(params[:id])
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

      def resource_methods
        only = Array(routing_options.fetch(:only, []))
        except = Array(routing_options.fetch(:except, []))

        if only.any? { |m| AVAILABLE_METHODS.include?(m) }
          return only.select { |m| AVAILABLE_METHODS.include?(m) }
        end

        if except.any? { |m| AVAILABLE_METHODS.include?(m) }
          return AVAILABLE_METHODS - except
        end

        AVAILABLE_METHODS
      end

    end
  end
end
