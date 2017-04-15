module Grape
  module ResourceRouting

    class << self
      def initialize options, &block
        instance_eval(&block)
      end

      def policies(options)
      end

      def cache_handlers(options)
      end

      def presenters(options)
      end

      def filters(options)
      end

      def serializers(options)
      end
    end

    # ===== Examples
    #
    #   class Posts < Grape::API
    #     
    #     resource_route :posts, as: Post, only: [:index, :show, :create, :update, :delete], public: false do
    #
    #       serializers default: PostSerializer do
    #         on :index, use: PostIndexSerializer
    #         on :show, use: PostDetailedSerializer
    #       end
    #       
    #       params :create, root: :post do
    #         requires :text, type: String
    #         optional :category_id, type: Integer
    #       end
    #
    #       params :update, root: :post do
    #         optional :text, type: String
    #         optional :category_id, type: Integer
    #       end
    #       
    #       filters do
    #         use :name, type: :string
    #         use :created_at, type: :date
    #       end
    #       
    #       post :batch_publish do
    #         posts = parent.posts.where(id: params[:_ids]) # or posts = company.posts
    #         posts.each(&:publish!)
    #         posts
    #       end
    #
    #       member do
    #         post :publish do
    #           resource.publish!
    #           resource
    #         end
    #       end
    #       
    #       rescue_for ActiveRecord::Invalid, status: :forbidden do
    #         resource.errors.keys.reduce {} do |hash, key|
    #           hash[key] = resource.errors.send(key)
    #         end
    #       end
    #
    #       belongs_to  :company
    #       presenter   PostPresenter
    #       policy      PostPolicy
    #       scope       PostScope
    #       cache       PostCacheHandler
    #     end
    #   end

    def route_resource options, &block
      @routes = (@routes || []) << Grape::ResourceRouting.new(options, &block)
    end
  end
end
Grape::API.extend(Grape::ResourceRouting)
