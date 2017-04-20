require 'spec_helper'

RSpec.describe Grape::Resource::Route, type: :resource do
  context 'when set route_for' do
    let(:posts_route_class) do
      Class.new(Grape::Resource::Route) do
        route_for Post, as: :posts
      end
    end

    before do
      stub_const 'Post', Class.new
      stub_const 'PostsRoute', posts_route_class
    end

    subject { PostsRoute.new }

    it 'should respond to resource_class' do
      should respond_to(:resource_class)
      expect(subject.resource_class).to eq(Post)
      expect(subject.resource_class_alias).to eq(:posts)
    end
  end
end
