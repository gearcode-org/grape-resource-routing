require 'spec_helper'

RSpec.describe Grape::Resource::Route, type: :resource do
  
  let(:routes) do
    subject.grape_route_class.routes.map { |e| [e.request_method, e.path.gsub(/\(.*\)/, '')] }
  end

  before do
    stub_const 'Post', Class.new
    stub_const 'PostsRoute', posts_route_class
  end

  subject { PostsRoute.new }

  context 'when set route_for' do
    let(:posts_route_class) do
      Class.new(Grape::Resource::Route) do
        route_for Post, as: :posts
      end
    end

    it 'should respond to resource_class' do
      should respond_to(:resource_class)
      expect(subject.resource_class).to eq(Post)
      expect(subject.resource_alias).to eq(:posts)
    end

    context 'only :index' do
      let(:posts_route_class) do
        Class.new(Grape::Resource::Route) do
          route_for Post, as: :posts, only: :index
        end
      end

      it '#grape_route_class should have route GET /posts' do
        expect(routes).to include(['GET', '/posts'])
        expect(routes).not_to include(['POST', '/posts'])
        expect(routes).not_to include(['GET', '/posts/:id'])
        expect(routes).not_to include(['PUT', '/posts/:id'])
        expect(routes).not_to include(['DELETE', '/posts/:id'])
      end
    end

    context 'except :index' do
      let(:posts_route_class) do
        Class.new(Grape::Resource::Route) do
          route_for Post, as: :posts, except: :index
        end
      end

      it '#grape_route_class should ignore route GET /posts' do
        expect(routes).not_to include(['GET', '/posts'])
        expect(routes).to include(['POST', '/posts'])
        expect(routes).to include(['GET', '/posts/:id'])
        expect(routes).to include(['PUT', '/posts/:id'])
        expect(routes).to include(['DELETE', '/posts/:id'])
      end
    end
  end

  context 'when create a custom endpoint "post :publish"' do
    let(:posts_route_class) do
      Class.new(Grape::Resource::Route) do
        route_for Post, as: :posts

        post :publish do
          # publish
        end
      end
    end

    it '#grape_route_class should have route POST /posts/publish' do
      should_not respond_to(:post)
      expect(subject.class).to respond_to(:post)
      expect(routes).to include(['POST', '/posts/publish'])
    end
  end
end
