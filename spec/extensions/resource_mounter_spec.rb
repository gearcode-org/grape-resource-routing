require 'spec_helper'

RSpec.describe Grape::Extensions::ResourceMounter, type: :extension do
  it { expect(Grape::API).to respond_to(:mount_resource) }

  context 'mounting route' do

    before do
      stub_const 'Post', Class.new
    end

    let(:routing_class) do
      Class.new(Grape::API) do
        mount_resource Post
      end
    end

    let(:mounted_routes) do
      routing_class.routes.map { |e| 
        [e.request_method, e.path.gsub(/\(.*\)/, '')] }
    end

    it 'endpoint for index, create, show, update, delete should be mounted' do
      expect(mounted_routes).to include(['GET', '/posts'])
      expect(mounted_routes).to include(['POST', '/posts'])
      expect(mounted_routes).to include(['GET', '/posts/:id'])
      expect(mounted_routes).to include(['PUT', '/posts/:id'])
      expect(mounted_routes).to include(['DELETE', '/posts/:id'])
    end
  end
end
