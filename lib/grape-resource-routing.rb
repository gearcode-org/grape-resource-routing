# ===== Examples
#
#   class Posts < Grape::Resource::Route
#     route_for   Post, as: :posts
#     public      false
#     only        [:index, :show, :create, :update, :delete]
#     except      [:show]
#     belongs_to  :company # use this feature to allow class access the parent resource. Otherwise, it can't
#     presenter   PostPresenter
#     policy      PostPolicy
#     scope       PostScope
#     cache       PostCacheHandler
#     
#     serializers default: PostSerializer do
#       on :index, use: PostIndexSerializer
#       on :show, use: PostDetailedSerializer
#     end
#       
#     params :create, root: :post do
#       requires :text, type: String
#       optional :category_id, type: Integer
#     end
#
#     params :update, root: :post do
#       optional :text, type: String
#       optional :category_id, type: Integer
#     end
#       
#     filters do
#       use :name, type: :string
#       use :created_at, type: :date
#     end
#       
#     post :batch_publish do
#       posts = parent.posts.where(id: params[:_ids]) # or posts = company.posts
#       posts.each(&:publish!)
#       posts
#     end
#
#     member do
#       post :publish do
#         resource.publish!
#         resource
#       end
#     end
#       
#     rescue_for ActiveRecord::Invalid, status: :forbidden do
#       resource.errors.keys.reduce {} do |hash, key|
#         hash[key] = resource.errors.send(key)
#       end
#     end
# 
#     mount_resource API::Comments
#   end

require 'grape'
require 'grape/extensions/resource_mounter'
